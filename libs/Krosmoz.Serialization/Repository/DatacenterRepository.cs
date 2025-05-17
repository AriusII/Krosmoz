// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using System.Diagnostics.CodeAnalysis;
using System.Globalization;
using Krosmoz.Serialization.Constants;
using Krosmoz.Serialization.D2I;
using Krosmoz.Serialization.D2O;
using Krosmoz.Serialization.D2O.Abstractions;
using Krosmoz.Serialization.D2P;
using Krosmoz.Serialization.DLM;
using Krosmoz.Serialization.ELE;
using Krosmoz.Serialization.I18N;
using Microsoft.Extensions.Logging;

namespace Krosmoz.Serialization.Repository;

/// <summary>
/// Provides methods to access and manage various datacenter files and resources.
/// </summary>
public sealed class DatacenterRepository : IDatacenterRepository
{
    private readonly I18NWrapper _i18N;
    private readonly IDatacenterObjectFactory _datacenterObjectFactory;
    private readonly ILogger<DatacenterRepository> _logger;

    /// <summary>
    /// Initializes a new instance of the <see cref="DatacenterRepository"/> class.
    /// </summary>
    /// <param name="datacenterObjectFactory">The factory for creating datacenter objects.</param>
    /// <param name="logger">The logger for logging information.</param>
    public DatacenterRepository(IDatacenterObjectFactory datacenterObjectFactory, ILogger<DatacenterRepository> logger)
    {
        _datacenterObjectFactory = datacenterObjectFactory;
        _logger = logger;

        _i18N = new I18NWrapper();
        _i18N.Load();
    }

    /// <summary>
    /// Retrieves the internationalization wrapper.
    /// </summary>
    /// <returns>An instance of <see cref="I18NWrapper"/>.</returns>
    public I18NWrapper GetI18N()
    {
        return _i18N;
    }

    /// <summary>
    /// Retrieves the graphical element file.
    /// </summary>
    /// <returns>An instance of <see cref="GraphicalElementFile"/>.</returns>
    public GraphicalElementFile GetEle()
    {
        return GraphicalElementAdapter.Load();
    }

    /// <summary>
    /// Retrieves the D2O file.
    /// </summary>
    /// <returns>An instance of <see cref="D2OFile"/>.</returns>
    public D2OFile GetD2O()
    {
        return new D2OFile(_datacenterObjectFactory, _i18N.GetD2I(I18NLanguages.French));
    }

    /// <summary>
    /// Retrieves the D2I file for the specified language.
    /// </summary>
    /// <param name="language">The language for which the D2I file is retrieved.</param>
    /// <returns>An instance of <see cref="D2IFile"/>.</returns>
    public D2IFile GetD2I(I18NLanguages language)
    {
        return _i18N.GetD2I(language);
    }

    /// <summary>
    /// Retrieves the D2P file for maps.
    /// </summary>
    /// <param name="fileName">The name of the D2P file. Defaults to "maps0.d2p".</param>
    /// <returns>An instance of <see cref="D2PFile"/>.</returns>
    public D2PFile GetMapD2P(string fileName = "maps0.d2p")
    {
        return new D2PFile(Path.Combine(PathConstants.Directories.MapsPath, fileName));
    }

    /// <summary>
    /// Retrieves the D2P file for tiles.
    /// </summary>
    /// <param name="fileName">The name of the D2P file. Defaults to "gfx0.d2p".</param>
    /// <returns>An instance of <see cref="D2PFile"/>.</returns>
    public D2PFile GetTilesD2P(string fileName = "gfx0.d2p")
    {
        return new D2PFile(Path.Combine(PathConstants.Directories.TilesPath, fileName));
    }

    /// <summary>
    /// Attempts to retrieve a map from the specified D2P file by its identifier.
    /// </summary>
    /// <param name="d2PFile">The D2P file containing the map data.</param>
    /// <param name="id">The identifier of the map to retrieve.</param>
    /// <param name="map">
    /// When this method returns, contains the retrieved <see cref="DlmMap"/> if the operation succeeds;
    /// otherwise, <c>null</c>.
    /// </param>
    /// <returns>
    /// <c>true</c> if the map was successfully retrieved; otherwise, <c>false</c>.
    /// </returns>
    public bool TryGetMap(D2PFile d2PFile, int id, [NotNullWhen(true)] out DlmMap? map)
    {
        if (d2PFile.TryGetEntry($"{id.ToString(CultureInfo.InvariantCulture).Last()}/{id}.dlm", out var entry))
        {
            map = DlmAdapter.Load(d2PFile.ReadFile(entry));
            return true;
        }

        map = null;
        return false;
    }

    /// <summary>
    /// Retrieves a list of objects of the specified type from the datacenter.
    /// </summary>
    /// <typeparam name="T">The type of objects to retrieve. Must implement <see cref="IDatacenterObject"/>.</typeparam>
    /// <param name="clearCache">Indicates whether to clear the cache before retrieving the objects. Defaults to <c>false</c>.</param>
    /// <returns>A list of objects of type <typeparamref name="T"/>.</returns>
    public IList<T> GetObjects<T>(bool clearCache = false) where T : class, IDatacenterObject
    {
        var d2OFile = GetD2O();
        var objects = d2OFile.GetObjects<T>(clearCache);

        _logger.LogInformation("Loaded {Count} objects of type {Type} from {Source}", objects.Count, T.ModuleName, "Datacenter");

        return objects;
    }
}
