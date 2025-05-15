// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using System.Diagnostics.CodeAnalysis;
using Krosmoz.Core.IO.Binary;

namespace Krosmoz.Serialization.D2P;

/// <summary>
/// Represents a D2P file.
/// </summary>
public sealed class D2PFile
{
    private readonly Dictionary<string, D2PEntry> _entries;
    private readonly List<D2PFile> _links;
    private readonly List<D2PProperty> _properties;
    private readonly Dictionary<string, D2PDirectory> _directories;
    private readonly BigEndianReader _reader;

    /// <summary>
    /// Gets a value indicating whether links to other D2P files should be registered.
    /// </summary>
    public bool RegisterLinks { get; }

    /// <summary>
    /// Gets the index table of the D2P file.
    /// </summary>
    public D2PIndexTable IndexTable { get; }

    /// <summary>
    /// Gets the file path of the D2P file.
    /// </summary>
    public string FilePath { get; }

    /// <summary>
    /// Gets the file name of the D2P file.
    /// </summary>
    public string FileName =>
        Path.GetFileName(FilePath);

    /// <summary>
    /// Gets the properties of the D2P file.
    /// </summary>
    public IEnumerable<D2PProperty> Properties =>
        _properties;

    /// <summary>
    /// Gets the entries in the D2P file.
    /// </summary>
    public IEnumerable<D2PEntry> Entries =>
        _entries.Values;

    /// <summary>
    /// Gets the linked D2P files.
    /// </summary>
    public IEnumerable<D2PFile> Links =>
        _links;

    /// <summary>
    /// Gets the root directories in the D2P file.
    /// </summary>
    public IEnumerable<D2PDirectory> RootDirectories =>
        _directories.Values;

    /// <summary>
    /// Gets a value indicating whether the file path is valid.
    /// </summary>
    public bool HasFilePath =>
        !string.IsNullOrEmpty(FilePath);

    /// <summary>
    /// Initializes a new instance of the <see cref="D2PFile"/> class.
    /// </summary>
    /// <param name="filePath">The file path of the D2P file.</param>
    /// <param name="registerLinks">Indicates whether links to other D2P files should be registered.</param>
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

    /// <summary>
    /// Reads the file data for the specified entry from the D2P file.
    /// </summary>
    /// <param name="entry">The entry to read the file data for.</param>
    /// <returns>A byte array containing the file data.</returns>
    public byte[] ReadFile(D2PEntry entry)
    {
        if (entry.Container != this)
            return entry.Container.ReadFile(entry);

        if (entry.Index >= 0 && IndexTable.OffsetBase + entry.Index >= 0)
            _reader.Seek(SeekOrigin.Begin, (int)IndexTable.OffsetBase + entry.Index);

        return entry.ReadEntry(_reader);
    }

    /// <summary>
    /// Gets the entries that belong only to this D2P file instance.
    /// </summary>
    /// <returns>An enumerable collection of entries.</returns>
    public IEnumerable<D2PEntry> GetEntriesOfInstanceOnly()
    {
        return _entries.Values.Where(entry => entry.Container == this);
    }

    /// <summary>
    /// Gets an entry by its file name.
    /// </summary>
    /// <param name="fileName">The file name of the entry.</param>
    /// <returns>The entry with the specified file name.</returns>
    public D2PEntry GetEntry(string fileName)
    {
        return _entries[fileName];
    }

    /// <summary>
    /// Tries to get an entry by its file name.
    /// </summary>
    /// <param name="fileName">The file name of the entry.</param>
    /// <param name="entry">When this method returns, contains the entry if found; otherwise, <c>null</c>.</param>
    /// <returns><c>true</c> if the entry was found; otherwise, <c>false</c>.</returns>
    public bool TryGetEntry(string fileName, [NotNullWhen(true)] out D2PEntry? entry)
    {
        return _entries.TryGetValue(fileName, out entry);
    }

    /// <summary>
    /// Gets the latest linked D2P file in the chain of links.
    /// </summary>
    /// <returns>The latest linked D2P file.</returns>
    public D2PFile GetLatestLink()
    {
        var lastLink = this;

        for (var link = _links.FirstOrDefault(); link is not null; link = link.Links.FirstOrDefault())
            lastLink = link;

        return lastLink;
    }

    /// <summary>
    /// Opens the D2P file and reads its contents.
    /// </summary>
    private void InternalOpen()
    {
        if (_reader.ReadUInt8() is not 2 || _reader.ReadUInt8() is not 1)
            throw new Exception("Invalid D2P file.");

        ReadTable();
        ReadProperties();
        ReadEntryDefinitions();
    }

    /// <summary>
    /// Reads the index table from the D2P file.
    /// </summary>
    private void ReadTable()
    {
        _reader.Seek(D2PIndexTable.TableSeekOrigin, D2PIndexTable.TableOffset);

        IndexTable.ReadTable(_reader);
    }

    /// <summary>
    /// Reads the properties from the D2P file.
    /// </summary>
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

    /// <summary>
    /// Reads the entry definitions from the D2P file.
    /// </summary>
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

    /// <summary>
    /// Adds a link to another D2P file.
    /// </summary>
    /// <param name="linkFile">The file path of the linked D2P file.</param>
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
    }

    /// <summary>
    /// Gets the absolute path of a linked file.
    /// </summary>
    /// <param name="linkFile">The relative or absolute path of the linked file.</param>
    /// <returns>The absolute path of the linked file.</returns>
    private string GetLinkFileAbsolutePath(string linkFile)
    {
        if (File.Exists(linkFile) || !HasFilePath)
            return linkFile;

        var absolutePath = Path.Combine(Path.GetDirectoryName(FilePath)!, linkFile);

        return File.Exists(absolutePath) ? absolutePath : linkFile;
    }

    /// <summary>
    /// Adds an entry to the D2P file.
    /// </summary>
    /// <param name="entry">The entry to add.</param>
    private void InternalAddEntry(D2PEntry entry)
    {
        if (TryGetEntry(entry.FullFileName, out var registerdEntry))
            _entries[registerdEntry.FullFileName] = entry;
        else
            _entries.TryAdd(entry.FullFileName, entry);

        InternalAddDirectories(entry);
    }

    /// <summary>
    /// Adds directories for an entry to the D2P file.
    /// </summary>
    /// <param name="entry">The entry for which directories are added.</param>
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
