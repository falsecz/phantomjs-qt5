# Copyright (c) 2012 The ANGLE Project Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

{
  'variables': {
    'angle_code': 1,
  },
  'target_defaults': {
    'defines': [
      'ANGLE_DISABLE_TRACE',
      'ANGLE_COMPILE_OPTIMIZATION_LEVEL=D3DCOMPILE_OPTIMIZATION_LEVEL1',
      'ANGLE_PRELOADED_D3DCOMPILER_MODULE_NAMES={ TEXT("d3dcompiler_46.dll"), TEXT("d3dcompiler_43.dll") }',
    ],
  },
  'targets': [
    {
      'target_name': 'preprocessor',
      'type': 'static_library',
      'include_dirs': [
      ],
      'sources': [
        'compiler/preprocessor/DiagnosticsBase.cpp',
        'compiler/preprocessor/DiagnosticsBase.h',
        'compiler/preprocessor/DirectiveHandlerBase.cpp',
        'compiler/preprocessor/DirectiveHandlerBase.h',
        'compiler/preprocessor/DirectiveParser.cpp',
        'compiler/preprocessor/DirectiveParser.h',
        'compiler/preprocessor/ExpressionParser.cpp',
        'compiler/preprocessor/ExpressionParser.h',
        'compiler/preprocessor/Input.cpp',
        'compiler/preprocessor/Input.h',
        'compiler/preprocessor/length_limits.h',
        'compiler/preprocessor/Lexer.cpp',
        'compiler/preprocessor/Lexer.h',
        'compiler/preprocessor/Macro.cpp',
        'compiler/preprocessor/Macro.h',
        'compiler/preprocessor/MacroExpander.cpp',
        'compiler/preprocessor/MacroExpander.h',
        'compiler/preprocessor/numeric_lex.h',
        'compiler/preprocessor/pp_utils.h',
        'compiler/preprocessor/Preprocessor.cpp',
        'compiler/preprocessor/Preprocessor.h',
        'compiler/preprocessor/SourceLocation.h',
        'compiler/preprocessor/Token.cpp',
        'compiler/preprocessor/Token.h',
        'compiler/preprocessor/Tokenizer.cpp',
        'compiler/preprocessor/Tokenizer.h',
      ],
      # TODO(jschuh): http://crbug.com/167187
      'msvs_disabled_warnings': [
        4267,
      ],      
    },
    {
      'target_name': 'translator_common',
      'type': 'static_library',
      'dependencies': ['preprocessor'],
      'include_dirs': [
        '.',
        '../include',
      ],
      'defines': [
        'COMPILER_IMPLEMENTATION',
      ],
      'sources': [
        'compiler/BaseTypes.h',
        'compiler/BuiltInFunctionEmulator.cpp',
        'compiler/BuiltInFunctionEmulator.h',
        'compiler/Common.h',
        'compiler/Compiler.cpp',
        'compiler/ConstantUnion.h',
        'compiler/debug.cpp',
        'compiler/debug.h',
        'compiler/DetectCallDepth.cpp',
        'compiler/DetectCallDepth.h',
        'compiler/Diagnostics.h',
        'compiler/Diagnostics.cpp',
        'compiler/DirectiveHandler.h',
        'compiler/DirectiveHandler.cpp',
        'compiler/ExtensionBehavior.h',
        'compiler/ForLoopUnroll.cpp',
        'compiler/ForLoopUnroll.h',
        'compiler/glslang.h',
        'compiler/glslang_lex.cpp',
        'compiler/glslang_tab.cpp',
        'compiler/glslang_tab.h',
        'compiler/HashNames.h',
        'compiler/InfoSink.cpp',
        'compiler/InfoSink.h',
        'compiler/Initialize.cpp',
        'compiler/Initialize.h',
        'compiler/InitializeDll.cpp',
        'compiler/InitializeDll.h',
        'compiler/InitializeGlobals.h',
        'compiler/InitializeParseContext.cpp',
        'compiler/InitializeParseContext.h',
        'compiler/Intermediate.cpp',
        'compiler/intermediate.h',
        'compiler/intermOut.cpp',
        'compiler/IntermTraverse.cpp',
        'compiler/localintermediate.h',
        'compiler/MapLongVariableNames.cpp',
        'compiler/MapLongVariableNames.h',
        'compiler/MMap.h',
        'compiler/osinclude.h',
        'compiler/parseConst.cpp',
        'compiler/ParseHelper.cpp',
        'compiler/ParseHelper.h',
        'compiler/PoolAlloc.cpp',
        'compiler/PoolAlloc.h',
        'compiler/QualifierAlive.cpp',
        'compiler/QualifierAlive.h',
        'compiler/RemoveTree.cpp',
        'compiler/RemoveTree.h',
        'compiler/RenameFunction.h',
        'compiler/ShHandle.h',
        'compiler/SymbolTable.cpp',
        'compiler/SymbolTable.h',
        'compiler/Types.h',
        'compiler/Uniform.cpp',
        'compiler/Uniform.h',
        'compiler/util.cpp',
        'compiler/util.h',
        'compiler/ValidateLimitations.cpp',
        'compiler/ValidateLimitations.h',
        'compiler/VariableInfo.cpp',
        'compiler/VariableInfo.h',
        'compiler/VariablePacker.cpp',
        'compiler/VariablePacker.h',
        # Dependency graph
        'compiler/depgraph/DependencyGraph.cpp',
        'compiler/depgraph/DependencyGraph.h',
        'compiler/depgraph/DependencyGraphBuilder.cpp',
        'compiler/depgraph/DependencyGraphBuilder.h',
        'compiler/depgraph/DependencyGraphOutput.cpp',
        'compiler/depgraph/DependencyGraphOutput.h',
        'compiler/depgraph/DependencyGraphTraverse.cpp',
        # Timing restrictions
        'compiler/timing/RestrictFragmentShaderTiming.cpp',
        'compiler/timing/RestrictFragmentShaderTiming.h',
        'compiler/timing/RestrictVertexShaderTiming.cpp',
        'compiler/timing/RestrictVertexShaderTiming.h',
        'third_party/compiler/ArrayBoundsClamper.cpp',
        'third_party/compiler/ArrayBoundsClamper.h',
      ],
      'conditions': [
        ['OS=="win"', {
          # TODO(jschuh): http://crbug.com/167187 size_t -> int
          'msvs_disabled_warnings': [ 4267 ],
          'sources': ['compiler/ossource_win.cpp'],
        }, { # else: posix
          'sources': ['compiler/ossource_posix.cpp'],
        }],
      ],
    },
    {
      'target_name': 'translator_glsl',
      'type': '<(component)',
      'dependencies': ['translator_common'],
      'include_dirs': [
        '.',
        '../include',
      ],
      'defines': [
        'COMPILER_IMPLEMENTATION',
      ],
      'sources': [
        'compiler/CodeGenGLSL.cpp',
        'compiler/OutputESSL.cpp',
        'compiler/OutputESSL.h',        
        'compiler/OutputGLSLBase.cpp',
        'compiler/OutputGLSLBase.h',
        'compiler/OutputGLSL.cpp',
        'compiler/OutputGLSL.h',
        'compiler/ShaderLang.cpp',
        'compiler/TranslatorESSL.cpp',
        'compiler/TranslatorESSL.h',
        'compiler/TranslatorGLSL.cpp',
        'compiler/TranslatorGLSL.h',
        'compiler/VersionGLSL.cpp',
        'compiler/VersionGLSL.h',
      ],
      # TODO(jschuh): http://crbug.com/167187 size_t -> int
      'msvs_disabled_warnings': [ 4267 ],
    },
  ],
  'conditions': [
    ['OS=="win"', {
      'targets': [
        {
          'target_name': 'translator_hlsl',
          'type': '<(component)',
          'dependencies': ['translator_common'],
          'include_dirs': [
            '.',
            '../include',
          ],
          'defines': [
            'COMPILER_IMPLEMENTATION',
          ],
          'sources': [
            'compiler/ShaderLang.cpp',
            'compiler/DetectDiscontinuity.cpp',
            'compiler/DetectDiscontinuity.h',
            'compiler/CodeGenHLSL.cpp',
            'compiler/OutputHLSL.cpp',
            'compiler/OutputHLSL.h',
            'compiler/TranslatorHLSL.cpp',
            'compiler/TranslatorHLSL.h',
            'compiler/UnfoldShortCircuit.cpp',
            'compiler/UnfoldShortCircuit.h',
            'compiler/SearchSymbol.cpp',
            'compiler/SearchSymbol.h',
          ],
          # TODO(jschuh): http://crbug.com/167187 size_t -> int
          'msvs_disabled_warnings': [ 4267 ],
        },
        {
          'target_name': 'libGLESv2',
          'type': 'shared_library',
          'dependencies': ['translator_hlsl'],
          'include_dirs': [
            '.',
            '../include',
            'libGLESv2',
          ],
          'sources': [
            'third_party/murmurhash/MurmurHash3.h',
            'third_party/murmurhash/MurmurHash3.cpp',
            'common/angleutils.h',
            'common/debug.cpp',
            'common/debug.h',
            'common/RefCountObject.cpp',
            'common/RefCountObject.h',
            'common/version.h',
            'libGLESv2/precompiled.h',
            'libGLESv2/precompiled.cpp',
            'libGLESv2/BinaryStream.h',
            'libGLESv2/Buffer.cpp',
            'libGLESv2/Buffer.h',
            'libGLESv2/constants.h',
            'libGLESv2/Context.cpp',
            'libGLESv2/Context.h',
            'libGLESv2/angletypes.h',
            'libGLESv2/Fence.cpp',
            'libGLESv2/Fence.h',
            'libGLESv2/Float16ToFloat32.cpp',
            'libGLESv2/Framebuffer.cpp',
            'libGLESv2/Framebuffer.h',
            'libGLESv2/HandleAllocator.cpp',
            'libGLESv2/HandleAllocator.h',
            'libGLESv2/libGLESv2.cpp',
            'libGLESv2/libGLESv2.def',
            'libGLESv2/libGLESv2.rc',
            'libGLESv2/main.cpp',
            'libGLESv2/main.h',
            'libGLESv2/mathutil.h',
            'libGLESv2/Program.cpp',
            'libGLESv2/Program.h',
            'libGLESv2/ProgramBinary.cpp',
            'libGLESv2/ProgramBinary.h',
            'libGLESv2/Query.h',
            'libGLESv2/Query.cpp',
            'libGLESv2/Renderbuffer.cpp',
            'libGLESv2/Renderbuffer.h',
            'libGLESv2/renderer/Blit.cpp',
            'libGLESv2/renderer/Blit.h',
            'libGLESv2/renderer/BufferStorage.h',
            'libGLESv2/renderer/BufferStorage.cpp',
            'libGLESv2/renderer/BufferStorage9.cpp',
            'libGLESv2/renderer/BufferStorage9.h',
            'libGLESv2/renderer/BufferStorage11.cpp',
            'libGLESv2/renderer/BufferStorage11.h',
            'libGLESv2/renderer/FenceImpl.h',
            'libGLESv2/renderer/Fence9.cpp',
            'libGLESv2/renderer/Fence9.h',
            'libGLESv2/renderer/Fence11.cpp',
            'libGLESv2/renderer/Fence11.h',
            'libGLESv2/renderer/generatemip.h',
            'libGLESv2/renderer/Image.cpp',
            'libGLESv2/renderer/Image.h',
            'libGLESv2/renderer/Image11.cpp',
            'libGLESv2/renderer/Image11.h',
            'libGLESv2/renderer/Image9.cpp',
            'libGLESv2/renderer/Image9.h',
            'libGLESv2/renderer/ImageSSE2.cpp',
            'libGLESv2/renderer/IndexBuffer.cpp',
            'libGLESv2/renderer/IndexBuffer.h',
            'libGLESv2/renderer/IndexBuffer9.cpp',
            'libGLESv2/renderer/IndexBuffer9.h',
            'libGLESv2/renderer/IndexBuffer11.cpp',
            'libGLESv2/renderer/IndexBuffer11.h',
            'libGLESv2/renderer/IndexDataManager.cpp',
            'libGLESv2/renderer/IndexDataManager.h',
            'libGLESv2/renderer/InputLayoutCache.cpp',
            'libGLESv2/renderer/InputLayoutCache.h',
            'libGLESv2/renderer/QueryImpl.h',
            'libGLESv2/renderer/Query9.cpp',
            'libGLESv2/renderer/Query9.h',
            'libGLESv2/renderer/Query11.cpp',
            'libGLESv2/renderer/Query11.h',
            'libGLESv2/renderer/Renderer.cpp',
            'libGLESv2/renderer/Renderer.h',
            'libGLESv2/renderer/Renderer11.cpp',
            'libGLESv2/renderer/Renderer11.h',
            'libGLESv2/renderer/renderer11_utils.cpp',
            'libGLESv2/renderer/renderer11_utils.h',
            'libGLESv2/renderer/Renderer9.cpp',
            'libGLESv2/renderer/Renderer9.h',
            'libGLESv2/renderer/renderer9_utils.cpp',
            'libGLESv2/renderer/renderer9_utils.h',
            'libGLESv2/renderer/RenderStateCache.cpp',
            'libGLESv2/renderer/RenderStateCache.h',
            'libGLESv2/renderer/RenderTarget.h',
            'libGLESv2/renderer/RenderTarget11.h',
            'libGLESv2/renderer/RenderTarget11.cpp',
            'libGLESv2/renderer/RenderTarget9.h',
            'libGLESv2/renderer/RenderTarget9.cpp',
            'libGLESv2/renderer/ShaderCache.h',
            'libGLESv2/renderer/ShaderExecutable.h',
            'libGLESv2/renderer/ShaderExecutable9.cpp',
            'libGLESv2/renderer/ShaderExecutable9.h',
            'libGLESv2/renderer/ShaderExecutable11.cpp',
            'libGLESv2/renderer/ShaderExecutable11.h',
            'libGLESv2/renderer/SwapChain.h',
            'libGLESv2/renderer/SwapChain9.cpp',
            'libGLESv2/renderer/SwapChain9.h',
            'libGLESv2/renderer/SwapChain11.cpp',
            'libGLESv2/renderer/SwapChain11.h',
            'libGLESv2/renderer/TextureStorage.cpp',
            'libGLESv2/renderer/TextureStorage.h',
            'libGLESv2/renderer/TextureStorage11.cpp',
            'libGLESv2/renderer/TextureStorage11.h',
            'libGLESv2/renderer/TextureStorage9.cpp',
            'libGLESv2/renderer/TextureStorage9.h',
            'libGLESv2/renderer/VertexBuffer.cpp',
            'libGLESv2/renderer/VertexBuffer.h',
            'libGLESv2/renderer/VertexBuffer9.cpp',
            'libGLESv2/renderer/VertexBuffer9.h',
            'libGLESv2/renderer/VertexBuffer11.cpp',
            'libGLESv2/renderer/VertexBuffer11.h',
            'libGLESv2/renderer/vertexconversion.h',
            'libGLESv2/renderer/VertexDataManager.cpp',
            'libGLESv2/renderer/VertexDataManager.h',
            'libGLESv2/renderer/VertexDeclarationCache.cpp',
            'libGLESv2/renderer/VertexDeclarationCache.h',
            'libGLESv2/ResourceManager.cpp',
            'libGLESv2/ResourceManager.h',
            'libGLESv2/Shader.cpp',
            'libGLESv2/Shader.h',
            'libGLESv2/Texture.cpp',
            'libGLESv2/Texture.h',
            'libGLESv2/Uniform.cpp',
            'libGLESv2/Uniform.h',
            'libGLESv2/utilities.cpp',
            'libGLESv2/utilities.h',
          ],
          # TODO(jschuh): http://crbug.com/167187 size_t -> int
          'msvs_disabled_warnings': [ 4267 ],
          'msvs_settings': {
            'VCLinkerTool': {
              'AdditionalDependencies': [
                'd3d9.lib',
                'dxguid.lib',
              ],
            }
          },
        },
        {
          'target_name': 'libEGL',
          'type': 'shared_library',
          'dependencies': ['libGLESv2'],
          'include_dirs': [
            '.',
            '../include',
            'libGLESv2',
          ],
          'sources': [
            'common/angleutils.h',
            'common/debug.cpp',
            'common/debug.h',
            'common/RefCountObject.cpp',
            'common/RefCountObject.h',
            'common/version.h',
            'libEGL/Config.cpp',
            'libEGL/Config.h',
            'libEGL/Display.cpp',
            'libEGL/Display.h',
            'libEGL/libEGL.cpp',
            'libEGL/libEGL.def',
            'libEGL/libEGL.rc',
            'libEGL/main.cpp',
            'libEGL/main.h',
            'libEGL/Surface.cpp',
            'libEGL/Surface.h',
          ],
          # TODO(jschuh): http://crbug.com/167187 size_t -> int
          'msvs_disabled_warnings': [ 4267 ],
          'msvs_settings': {
            'VCLinkerTool': {
              'AdditionalDependencies': [
                'd3d9.lib',
              ],
            }
          },
        },
      ],
    }],
  ],
}

# Local Variables:
# tab-width:2
# indent-tabs-mode:nil
# End:
# vim: set expandtab tabstop=2 shiftwidth=2:
# Copyright (c) 2012 The ANGLE Project Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.
