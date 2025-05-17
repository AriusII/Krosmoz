// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using Krosmoz.SourceGenerators.Initialization.Models;
using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp.Syntax;

namespace Krosmoz.SourceGenerators.Initialization;

public sealed partial class InitializationSourceGenerator
{
    /// <summary>
    /// Determines whether the specified syntax node matches the criteria for initialization services.
    /// </summary>
    /// <param name="syntaxNode">The syntax node to evaluate.</param>
    /// <param name="cancellationToken">A token to monitor for cancellation requests.</param>
    /// <returns>
    /// <c>true</c> if the syntax node is a class declaration that implements
    /// <b>IInitializableService</b> or <b>IAsyncInitializableService</b>; otherwise, <c>false</c>.
    /// </returns>
    private static bool Predicate(SyntaxNode syntaxNode, CancellationToken cancellationToken)
    {
        cancellationToken.ThrowIfCancellationRequested();

        if (syntaxNode is not ClassDeclarationSyntax declarationSyntax)
            return false;

        return declarationSyntax.BaseList is not null &&
               declarationSyntax.BaseList.Types.Any(static t => t.Type.ToString() is "IInitializableService" or "IAsyncInitializableService");
    }

    /// <summary>
    /// Transforms a syntax node into an <see cref="InitializableService"/> object.
    /// </summary>
    /// <param name="context">The syntax context containing the node and semantic model.</param>
    /// <param name="cancellationToken">A token to monitor for cancellation requests.</param>
    /// <returns>An <see cref="InitializableService"/> object representing the transformed syntax node.</returns>
    /// <exception cref="Exception">Thrown if the symbol cannot be retrieved from the syntax node.</exception>
    private static InitializableService Transform(GeneratorSyntaxContext context, CancellationToken cancellationToken)
    {
        cancellationToken.ThrowIfCancellationRequested();

        if (context.SemanticModel.GetDeclaredSymbol(context.Node) is not INamedTypeSymbol symbol)
            throw new Exception("Unable to get symbol from syntax node.");

        var symbolName = symbol.ToDisplayString(SymbolDisplayFormat.FullyQualifiedFormat);

        var @interface = symbol.Interfaces.First(x => x.Name is "IInitializableService" or "IAsyncInitializableService");

        var isAsync = @interface.Name.Contains("Async");

        return new InitializableService(symbolName, isAsync);
    }
}
