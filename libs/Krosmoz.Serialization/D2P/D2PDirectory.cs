// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

namespace Krosmoz.Serialization.D2P;

public sealed class D2PDirectory
{
    public D2PFile Container { get; set; }

    public string Name
    {
        get;
        set
        {
            field = value;
            UpdateFullName();
        }
    }

    public string FullName { get; set; }

    public D2PDirectory? Parent
    {
        get;
        set
        {
            field = value;
            UpdateFullName();
        }
    }

    public List<D2PEntry> Entries { get; set; }

    public Dictionary<string, D2PDirectory> Directories { get; set; }

    public bool IsRoot =>
        Parent is null;

    public D2PDirectory(D2PFile container, string name)
    {
        Container = container;
        Name = name;
        FullName = name;
        Entries = [];
        Directories = [];
    }

    private void UpdateFullName()
    {
        FullName = Name;

        for (var current = this; current.Parent is not null; current = current.Parent)
            FullName = FullName.Insert(0, current.Parent.Name + "\\");
    }

    public bool HasDirectory(string directory)
    {
        return Directories.ContainsKey(directory);
    }

    public D2PDirectory? GetDirectory(string name)
    {
        return Directories.GetValueOrDefault(name);
    }

    public bool HasEntry(string entryName)
    {
        return Entries.Any(entry => entry.FullFileName == entryName);
    }

    public D2PEntry? GetEntry(string entryName)
    {
        return Entries.SingleOrDefault(entry => entry.FullFileName == entryName);
    }

    public IEnumerable<D2PEntry> GetAllEntries()
    {
        return Entries.Concat(Directories.SelectMany(static x => x.Value.GetAllEntries()));
    }
}
