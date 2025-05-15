// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using System.Diagnostics.CodeAnalysis;
using System.Text;
using Krosmoz.Core.IO.Binary;
using Krosmoz.Serialization.Constants;
using Krosmoz.Serialization.D2I;
using Krosmoz.Serialization.D2O.Abstractions;

namespace Krosmoz.Serialization.D2O;

/// <summary>
/// Represents a D2O file.
/// </summary>
public sealed class D2OFile
{
    private readonly Dictionary<string, Dictionary<int, D2OClass>> _classes;
    private readonly Dictionary<string, int> _counters;
    private readonly Dictionary<string, Dictionary<int, int>> _indexes;
    private readonly Dictionary<string, BigEndianReader> _readers;
    private readonly Dictionary<string, int> _readersStartIndexes;
    private readonly IDatacenterObjectFactory _datacenterObjectFactory;
    private readonly D2IFile _d2IFile;

    /// <summary>
    /// Initializes a new instance of the <see cref="D2OFile"/> class.
    /// </summary>
    /// <param name="datacenterObjectFactory">The factory for creating datacenter objects.</param>
    /// <param name="d2IFile">The associated D2I file for internationalized text.</param>
    public D2OFile(IDatacenterObjectFactory datacenterObjectFactory, D2IFile d2IFile)
    {
        _datacenterObjectFactory = datacenterObjectFactory;
        _d2IFile = d2IFile;
        _classes = [];
        _counters = [];
        _indexes = [];
        _readers = [];
        _readersStartIndexes = [];
    }

    /// <summary>
    /// Loads a D2O module by its name, initializing its reader, indexes, and classes.
    /// </summary>
    /// <param name="filePath">The path to the D2O file to load.</param>
    public void Load(string filePath)
    {
        var moduleName = Path.GetFileNameWithoutExtension(filePath);

        if (!_readers.TryGetValue(moduleName, out var reader))
        {
            _readers[moduleName] = reader = new BigEndianReader(File.ReadAllBytes(filePath));
            _readersStartIndexes[moduleName] = 7;
        }
        else
            reader.Seek(SeekOrigin.Begin, 0);

        var indexes = new Dictionary<int, int>();

        _indexes[moduleName] = indexes;

        var header = Encoding.ASCII.GetString(reader.ReadSpan(3));
        var contentOffset = 0;

        if (header is not "D2O")
        {
            reader.Seek(SeekOrigin.Begin, 0);

            header = reader.ReadUtfPrefixedLength16();

            if (header is not "AKSF")
                throw new Exception("Unexpected file format.");

            reader.Seek(SeekOrigin.Current, sizeof(short));
            reader.Seek(SeekOrigin.Current, reader.ReadInt32());

            contentOffset = reader.Position;

            _readersStartIndexes[moduleName] = contentOffset + 7;

            header = Encoding.ASCII.GetString(reader.ReadSpan(3));

            if (header is not "D2O")
                throw new Exception("Unexpected file format.");
        }

        var indexesPointer = reader.ReadInt32();
        reader.Seek(SeekOrigin.Begin, contentOffset + indexesPointer);
        var indexesCount = reader.ReadInt32();

        var count = 0;

        for (var i = 0; i < indexesCount; i += 8)
        {
            var key = reader.ReadInt32();
            var pointer = reader.ReadInt32();

            indexes[key] = contentOffset + pointer;
            count++;
        }

        _counters[moduleName] = count;

        var classes = new Dictionary<int, D2OClass>();

        _classes[moduleName] = classes;

        var classesCount = reader.ReadInt32();

        for (var i = 0; i < classesCount; i++)
        {
            var classId = reader.ReadInt32();
            var classDefinition = ReadClassDefinition(reader, moduleName);

            _classes[moduleName][classId] = classDefinition;
        }
    }

    /// <summary>
    /// Retrieves a list of objects of the specified type from the D2O file.
    /// </summary>
    /// <typeparam name="T">The type of objects to retrieve.</typeparam>
    /// <param name="clearReader">Whether to clear the reader after retrieving objects.</param>
    /// <returns>A list of objects of the specified type.</returns>
    public IList<T> GetObjects<T>(bool clearReader = false)
        where T : class, IDatacenterObject
    {
        var moduleName = T.ModuleName;

        if (!TryExtractInformations(moduleName, out var length, out var reader, out var classes, out var startIndex))
        {
            var filePath = moduleName is "ActionDescriptions"
                ? Path.Combine(PathConstants.Directories.CommonPath, string.Concat(moduleName, ".d2os"))
                : Path.Combine(PathConstants.Directories.CommonPath, string.Concat(moduleName, ".d2o"));

            Load(filePath);

            if (!TryExtractInformations(moduleName, out length, out reader, out classes, out startIndex))
                throw new Exception($"Module {moduleName} not found.");
        }

        reader.Seek(SeekOrigin.Begin, startIndex);

        var objects = new T[length];

        for (var i = 0; i < length; i++)
            objects[i] = classes[reader.ReadInt32()].Deserialize<T>(reader);

        if (clearReader)
            ResetReader(moduleName);

        return objects;
    }

    /// <summary>
    /// Retrieves the dictionary of classes defined in the D2O file.
    /// </summary>
    /// <returns>A dictionary of classes organized by module name and class ID.</returns>
    public Dictionary<string, Dictionary<int, D2OClass>> GetClasses()
    {
        return _classes;
    }

    /// <summary>
    /// Retrieves the associated D2I file for internationalized text.
    /// </summary>
    /// <returns>The associated D2I file.</returns>
    internal D2IFile GetD2IFile()
    {
        return _d2IFile;
    }

    /// <summary>
    /// Retrieves a class definition by its module name and ID.
    /// </summary>
    /// <param name="moduleName">The name of the module containing the class.</param>
    /// <param name="id">The ID of the class to retrieve.</param>
    /// <returns>The class definition.</returns>
    internal D2OClass GetClass(string moduleName, int id)
    {
        return _classes[moduleName][id];
    }

    /// <summary>
    /// Reads a class definition from the binary reader for the specified module.
    /// </summary>
    /// <param name="reader">The binary reader to read data from.</param>
    /// <param name="moduleName">The name of the module containing the class.</param>
    /// <returns>The class definition read from the reader.</returns>
    private D2OClass ReadClassDefinition(BigEndianReader reader, string moduleName)
    {
        var name = reader.ReadUtfPrefixedLength16();
        var @namespace = reader.ReadUtfPrefixedLength16();

        var classDefinition = new D2OClass(this, _datacenterObjectFactory, moduleName,@namespace, name);

        var fieldsCount = reader.ReadInt32();

        for (var i = 0; i < fieldsCount; i++)
        {
            var fieldName = reader.ReadUtfPrefixedLength16();
            var fieldType = reader.ReadInt32();

            var innerTypeNames = new List<string>();
            var innerTypeIds = new List<int>();

            var currentFieldType = fieldType;

            while (currentFieldType is -99)
            {
                innerTypeNames.Add(reader.ReadUtfPrefixedLength16());
                innerTypeIds.Add(currentFieldType = reader.ReadInt32());
            }

            classDefinition.Fields.Add(new D2OField(fieldName, fieldType, innerTypeNames, innerTypeIds));
        }

        return classDefinition;
    }

    /// <summary>
    /// Attempts to extract information about a module, including its length, reader, classes, and start index.
    /// </summary>
    /// <param name="moduleName">The name of the module to extract information for.</param>
    /// <param name="length">The length of the module.</param>
    /// <param name="reader">The binary reader for the module.</param>
    /// <param name="classes">The dictionary of classes for the module.</param>
    /// <param name="startIndex">The start index for the module's reader.</param>
    /// <returns><c>true</c> if the information was successfully extracted; otherwise, <c>false</c>.</returns>
    private bool TryExtractInformations(
        string moduleName,
        out int length,
        [NotNullWhen(true)] out BigEndianReader? reader,
        [NotNullWhen(true)] out Dictionary<int, D2OClass>? classes,
        out int startIndex)
    {
        length = 0;
        reader = null;
        classes = null;
        startIndex = 0;

        return _counters.TryGetValue(moduleName, out length) &&
               _readers.TryGetValue(moduleName, out reader) &&
               _classes.TryGetValue(moduleName, out classes) &&
               _readersStartIndexes.TryGetValue(moduleName, out startIndex);
    }

    /// <summary>
    /// Resets the reader and clears cached data for the specified module.
    /// </summary>
    /// <param name="moduleName">The name of the module to reset.</param>
    private void ResetReader(string moduleName)
    {
        _classes.Remove(moduleName);
        _counters.Remove(moduleName);
        _readers.Remove(moduleName);
    }
}
