// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using Krosmoz.Serialization.D2I;
using Krosmoz.Serialization.D2O;
using Krosmoz.Serialization.D2O.Abstractions;
using Krosmoz.Serialization.D2P;
using Krosmoz.Serialization.DLM;
using Krosmoz.Serialization.ELE;
using Krosmoz.Serialization.I18N;

namespace Krosmoz.Serialization.Repository;

/// <summary>
/// Defines a repository interface for accessing various datacenter files and resources.
/// </summary>
public interface IDatacenterRepository
{
    /// <summary>
    /// Retrieves the internationalization wrapper.
    /// </summary>
    /// <returns>An instance of <see cref="I18NWrapper"/>.</returns>
    I18NWrapper GetI18N();

    /// <summary>
    /// Retrieves the graphical element file.
    /// </summary>
    /// <returns>An instance of <see cref="GraphicalElementFile"/>.</returns>
    GraphicalElementFile GetEle();

    /// <summary>
    /// Retrieves the D2O file.
    /// </summary>
    /// <returns>An instance of <see cref="D2OFile"/>.</returns>
    D2OFile GetD2O();

    /// <summary>
    /// Retrieves the D2I file for the specified language.
    /// </summary>
    /// <param name="language">The language for which the D2I file is retrieved.</param>
    /// <returns>An instance of <see cref="D2IFile"/>.</returns>
    D2IFile GetD2I(I18NLanguages language);

    /// <summary>
    /// Retrieves the D2P file for maps.
    /// </summary>
    /// <param name="fileName">The name of the D2P file. Defaults to "maps0.d2p".</param>
    /// <returns>An instance of <see cref="D2PFile"/>.</returns>
    D2PFile GetMapD2P(string fileName = "maps0.d2p");

    /// <summary>
    /// Retrieves the D2P file for tiles.
    /// </summary>
    /// <param name="fileName">The name of the D2P file. Defaults to "gfx0.d2p".</param>
    /// <returns>An instance of <see cref="D2PFile"/>.</returns>
    D2PFile GetTilesD2P(string fileName = "gfx0.d2p");

    /// <summary>
    /// Retrieves a map from the specified D2P file using its ID.
    /// </summary>
    /// <param name="d2PFile">The D2P file containing the map.</param>
    /// <param name="id">The ID of the map to retrieve.</param>
    /// <returns>An instance of <see cref="DlmMap"/>.</returns>
    DlmMap GetMap(D2PFile d2PFile, int id);

    /// <summary>
    /// Retrieves a list of objects of the specified type from the datacenter.
    /// </summary>
    /// <typeparam name="T">The type of objects to retrieve.</typeparam>
    /// <param name="clearCache">Indicates whether to clear the cache before retrieving the objects. Defaults to <c>false</c>.</param>
    /// <returns>A list of objects of type <typeparamref name="T"/>.</returns>
    IList<T> GetObjects<T>(bool clearCache = false)
        where T : class, IDatacenterObject;
}
