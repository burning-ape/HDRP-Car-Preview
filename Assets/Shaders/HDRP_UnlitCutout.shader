Shader "Custom/HDRP_UnlitCutout"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo", 2D) = "white" {}
        [NoScaleOffset]_OpacityMap ("OpacityMap", 2D) = "white" {}
        _Opacity ("Opacity", Range(0, 2)) = 0.5
    }
    SubShader
    {
        Tags {"RenderType"="TransparentCutout" "Queue"="Transparent" "RenderPipeline" = "HighDefinitionRenderPipeline"}
        Cull Off

        Pass
        {    
            HLSLPROGRAM


            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"


            fixed4 _Color;

            sampler2D _MainTex;
            float4 _MainTex_ST;

            sampler2D _OpacityMap;
            float4 _OpacityMap_ST;
            float _Opacity;


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
                clip(col.a - _Opacity);

                return col;
            };

            ENDHLSL
        }
    }
}
