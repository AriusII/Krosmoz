// Copyright (c) Krosmoz 2025.
// Krosmoz licenses this file to you under the MIT license.
// See the license here https://github.com/AerafalGit/Krosmoz/blob/main/LICENSE.

using Microsoft.CodeAnalysis;

namespace Krosmoz.SourceGeneration.MessageHandler;

/// <summary>
/// Represents a source generator for creating message handler-related code.
/// </summary>
[Generator(LanguageNames.CSharp)]
public sealed partial class MessageHandlerSourceGenerator : IIncrementalGenerator
{
    /// <summary>
    /// Initializes the incremental source generator by setting up the syntax provider and
    /// registering the source output generation logic.
    /// </summary>
    /// <param name="context">The <see cref="IncrementalGeneratorInitializationContext"/> used to configure the generator.</param>
    public void Initialize(IncrementalGeneratorInitializationContext context)
    {
        var syntaxProvider = context.SyntaxProvider.CreateSyntaxProvider(Predicate, Transform).Collect();

        context.RegisterSourceOutput(syntaxProvider, Generate);
    }
}
