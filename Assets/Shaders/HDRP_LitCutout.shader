Shader "Custom/HDRP_LitCutout"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo", 2D) = "white" {}
        [NoScaleOffset]_OpacityMap ("OpacityMap", 2D) = "white" {}
    }

    HLSLINCLUDE

    #pragma target 4.5
    #pragma only_renderers d3d11 playstation xboxone xboxseries vulkan metal switch
    #pragma multi_compile_instancing
    #pragma multi_compile _ DOTS_INSTANCING_ON

    ENDHLSL

    SubShader
    {
        Pass
        {
            Name "FirstPass"
            Tags { "LightMode" = "FirstPass" }

            Blend Off
            ZWrite Off
            ZTest LEqual

            Cull Back

            HLSLPROGRAM

            // Toggle the alpha test
            #define _ALPHATEST_ON

            // Toggle transparency
            // #define _SURFACE_TYPE_TRANSPARENT

            // Toggle fog on transparent
            #define _ENABLE_FOG_ON_TRANSPARENT
            
            // List all the attributes needed in your shader (will be passed to the vertex shader)
            // you can see the complete list of these attributes in VaryingMesh.hlsl
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT

            // List all the varyings needed in your fragment shader
            #define VARYINGS_NEED_TEXCOORD0
            #define VARYINGS_NEED_TANGENT_TO_WORLD
            
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/RenderPass/CustomPass/CustomPassRenderers.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/VertMesh.hlsl"

            float4 _ColorMap_ST;
            float4 _Color;

            PackedVaryingsType Vert(AttributesMesh inputMesh)
            {
                VaryingsType varyingsType;
                varyingsType.vmesh = VertMesh(inputMesh);
                return PackVaryingsType(varyingsType);
            }

            float4 Frag(PackedVaryingsToPS packedInput) : SV_Target
            {

                float4 outColor = float4(0.6, 0.6, 0.6, 1.0);
                return outColor;
            }

            #pragma vertex Vert
            #pragma fragment Frag

            ENDHLSL
        }

        // Copy fromm shader graph default shader
        Pass
        {
            Name "ShadowCaster"
            Tags
            {
                "LightMode" = "ShadowCaster"
            }
            // Render State
            Cull[_CullMode]
            ZWrite On
            ColorMask 0
            ZClip[_ZClip]

            HLSLPROGRAM
            #include "ShadowPass.hlsl"
            ENDHLSL
        }

        Pass
        {    
            Tags {"RenderType"="TransparentCutout" "Queue"="Transparent" "RenderPipeline" = "HighDefinitionRenderPipeline"}
            Cull Off

            HLSLPROGRAM

            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            fixed4 _Color;
            sampler2D _MainTex;
            float4 _MainTex_ST;
            sampler2D _OpacityMap;
            float4 _OpacityMap_ST;


            struct appdata 
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };


            struct v2f
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
            };


            v2f vert (appdata v)
            {
                v2f o;

                o.vertex  = UnityObjectToClipPos(v.vertex);      
                o.uv  = TRANSFORM_TEX(v.uv, _MainTex);     

                return o;
            };


            fixed4 frag (v2f v) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, v.uv) * _Color;
                fixed4 opacity = tex2D(_OpacityMap, v.uv);

                col *= opacity;
                clip(col.a - 0.5);

                return col;
            };

            ENDHLSL
        }
      
    }
}
