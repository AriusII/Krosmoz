// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using System.Diagnostics.CodeAnalysis;
using Krosmoz.Core.Cache;
using Krosmoz.Core.IO.Binary;

namespace Krosmoz.Serialization.D2P;

public sealed class D2PFile : ObjectModel
{
    private readonly Dictionary<string, D2PEntry> _entries;
    private readonly List<D2PFile> _links;
    private readonly List<D2PProperty> _properties;
    private readonly Dictionary<string, D2PDirectory> _directories;
    private readonly BigEndianReader _reader;

    public bool RegisterLinks { get; }

    public D2PIndexTable IndexTable { get; }

    public string FilePath { get; }

    public string FileName =>
        Path.GetFileName(FilePath);

    public IEnumerable<D2PProperty> Properties =>
        _properties;

    public IEnumerable<D2PEntry> Entries =>
        _entries.Values;

    public IEnumerable<D2PFile> Links =>
        _links;

    public IEnumerable<D2PDirectory> RootDirectories =>
        _directories.Values;

    public bool HasFilePath =>
        !string.IsNullOrEmpty(FilePath);

    public D2PFile(string filePath, bool registerLinks = true)
    {
        RegisterLinks = registerLinks;
        IndexTable = new D2PIndexTable(this);
        FilePath = filePath;

        _reader = new BigEndianReader(File.ReadAllBytes(filePath));
        _entries = [];
        _links = [];
        _properties = [];
        _directories = [];

        InternalOpen();
    }

    public IEnumerable<D2PEntry> GetEntriesOfInstanceOnly()
    {
        return _entries.Values.Where(entry => entry.Container == this);
    }

    public D2PEntry GetEntry(string fileName)
    {
        return _entries[fileName];
    }

    public bool TryGetEntry(string fileName, [NotNullWhen(true)] out D2PEntry? entry)
    {
        return _entries.TryGetValue(fileName, out entry);
    }

    public D2PFile GetLatestLink()
    {
        var lastLink = this;

        for (var link = _links.FirstOrDefault(); link is not null; link = link.Links.FirstOrDefault())
            lastLink = link;

        return lastLink;
    }

    private void InternalOpen()
    {
        if (_reader.ReadUInt8() is not 2 || _reader.ReadUInt8() is not 1)
            throw new Exception("Invalid D2P file.");

        ReadTable();
        ReadProperties();
        ReadEntryDefinitions();
    }

    private void ReadTable()
    {
        _reader.Seek(D2PIndexTable.TableSeekOrigin, D2PIndexTable.TableOffset);

        IndexTable.ReadTable(_reader);
    }

    private void ReadProperties()
    {
        _reader.Seek(SeekOrigin.Begin, (int)IndexTable.PropertiesOffset);

        for (var i = 0; i < IndexTable.PropertiesCount; i++)
        {
            var property = new D2PProperty();
            property.Deserialize(_reader);

            if (property.Key is "link")
                InternalAddLink(property.Value);

            _properties.Add(property);
        }
    }

    private void ReadEntryDefinitions()
    {
        _reader.Seek(SeekOrigin.Begin, (int)IndexTable.EntriesDefinitionOffset);

        for (var i = 0; i < IndexTable.EntriesCount; i++)
        {
            var entry = new D2PEntry(this);
            entry.ReadEntryDefinition(_reader);
            InternalAddEntry(entry);
        }
    }

    private void InternalAddLink(string linkFile)
    {
        var path = GetLinkFileAbsolutePath(linkFile);

        if (!File.Exists(path))
            throw new FileNotFoundException(linkFile);

        var link = new D2PFile(path);

        if (RegisterLinks)
        {
            foreach (var entry in link.Entries)
                InternalAddEntry(entry);
        }

        _links.Add(link);
        OnPropertyChanged(nameof(Links));
    }

    private string GetLinkFileAbsolutePath(string linkFile)
    {
        if (File.Exists(linkFile) || !HasFilePath)
            return linkFile;

        var absolutePath = Path.Combine(Path.GetDirectoryName(FilePath)!, linkFile);

        return File.Exists(absolutePath) ? absolutePath : linkFile;
    }

    private void InternalAddEntry(D2PEntry entry)
    {
        if (TryGetEntry(entry.FullFileName, out var registerdEntry))
            _entries[registerdEntry.FullFileName] = entry;
        else
            _entries.TryAdd(entry.FullFileName, entry);

        InternalAddDirectories(entry);
    }

    private void InternalAddDirectories(D2PEntry entry)
    {
        var directories = entry.GetDirectoryNames();

        if (directories.Length is 0)
            return;

        D2PDirectory? current;

        if (!_directories.TryGetValue(directories[0], out var value))
            _directories.TryAdd(directories[0], current = new D2PDirectory(this, directories[0]));
        else
            current = value;

        if (directories.Length == 1)
            current.Entries.Add(entry);

        for (var i = 1; i < directories.Length; i++)
        {
            var directory = directories[i];
            var next= current.GetDirectory(directory);

            if (next is null)
            {
                var dir = new D2PDirectory(this, directory) { Parent = current };
                current.Directories.Add(directory, dir);
                current = dir;
            }
            else
                current = next;

            if (i == directories.Length - 1)
                current.Entries.Add(entry);
        }

        entry.Directory = current;
    }
}
