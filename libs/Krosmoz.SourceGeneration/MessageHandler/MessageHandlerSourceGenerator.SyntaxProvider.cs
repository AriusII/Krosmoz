// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using Krosmoz.SourceGeneration.MessageHandler.Models;
using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp.Syntax;

namespace Krosmoz.SourceGeneration.MessageHandler;

public sealed partial class MessageHandlerSourceGenerator
{
    /// <summary>
    /// Evaluates whether a given syntax node matches the criteria for being a message handler method.
    /// </summary>
    /// <param name="syntaxNode">The syntax node to evaluate.</param>
    /// <param name="cancellationToken">A token to monitor for cancellation requests.</param>
    /// <returns>
    /// <c>true</c> if the syntax node represents a method with the required attributes and parameters; otherwise, <c>false</c>.
    /// </returns>
    private static bool Predicate(SyntaxNode syntaxNode, CancellationToken cancellationToken)
    {
        return !cancellationToken.IsCancellationRequested &&
               syntaxNode is MethodDeclarationSyntax { AttributeLists.Count: > 0, ParameterList.Parameters.Count: 2 } method &&
               method.AttributeLists.Any(static x => x.Attributes.Any(static y => y.Name.ToString() is "MessageHandler"));
    }

    /// <summary>
    /// Transforms a syntax node into a <see cref="Handler"/> object containing metadata about the method.
    /// </summary>
    /// <param name="context">The context providing semantic information about the syntax node.</param>
    /// <param name="cancellationToken">A token to monitor for cancellation requests.</param>
    /// <returns>
    /// A <see cref="Handler"/> object containing the fully qualified type name, method name, and parameter types.
    /// </returns>
    /// <exception cref="OperationCanceledException">Thrown if the operation is canceled.</exception>
    private static Handler Transform(GeneratorSyntaxContext context, CancellationToken cancellationToken)
    {
        cancellationToken.ThrowIfCancellationRequested();

        var method = (IMethodSymbol)context.SemanticModel.GetDeclaredSymbol(context.Node)!;

        var methodName = method.Name;

        var containingTypeName = method.ContainingType.ToDisplayString(SymbolDisplayFormat.FullyQualifiedFormat);

        var sessionTypeName = method.Parameters[0].Type.ToDisplayString(SymbolDisplayFormat.FullyQualifiedFormat);
        var messageTypeName = method.Parameters[1].Type.ToDisplayString(SymbolDisplayFormat.FullyQualifiedFormat);

        return new Handler(containingTypeName, methodName, sessionTypeName, messageTypeName);
    }
}
