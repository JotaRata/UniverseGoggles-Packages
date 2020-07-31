// Upgrade NOTE: upgraded instancing buffer 'MyProperties' to new syntax.

// Upgrade NOTE: upgraded instancing buffer 'MyProperties' to new syntax.

Shader "LWRP/DiffractionPoint"
{
    Properties
    {
        [PerRendererData]_COLOR("Color", Color) = (1,1,1,1)
        _VALUE("Intensity", Float) = 1
        _SIZE("Size", Range(0, 1)) = 1
        _POWER("Power", Range(0,2)) = 0.5
        _OFFSET("Offset", Range(0, 1)) = 0
    }
    SubShader
    {
        Tags { "Queue"="Transparent" "PreviewType" = "Plane"}
        LOD 100
        Cull Off
        Blend One One
        ZWrite Off
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_instancing

            #include "UnityCG.cginc"

            struct appdata
            {
                half4 vertex : POSITION;
                half2 uv : TEXCOORD0;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct v2f
            {
                half2 uv : TEXCOORD0;
                half4 vertex : SV_POSITION;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            UNITY_INSTANCING_BUFFER_START(MyProperties)
                UNITY_DEFINE_INSTANCED_PROP(float4, _COLOR)
            #define _COLOR_arr MyProperties
            UNITY_INSTANCING_BUFFER_END(MyProperties)

            half _SIZE;
            half _VALUE;
            half _POWER;
            half _OFFSET;
            v2f vert (appdata v)
            {
                v2f o;
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_TRANSFER_INSTANCE_ID(v, o);
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }
            void Unity_Saturation_float(float3 In, float Saturation, out float3 Out)
            {
                float luma = dot(In, float3(0.2126729, 0.7151522, 0.0721750));
                Out =  luma.xxx + Saturation.xxx * (In - luma.xxx);
            }
            fixed4 frag (v2f i) : SV_Target
            {
                UNITY_SETUP_INSTANCE_ID(i);
                half dist = (i.uv.x - 0.5)*(i.uv.x - 0.5) + (i.uv.y - 0.5)*(i.uv.y - 0.5);
                fixed4 col = UNITY_ACCESS_INSTANCED_PROP(_COLOR_arr, _COLOR) * _VALUE * (_SIZE / pow(dist, _POWER) - _OFFSET);
                col = clamp(col, 0, 1000);
                //fixed4 col = clamp((_SIZE - dist) * UNITY_ACCESS_INSTANCED_PROP(_COLOR_arr, _COLOR) * _VALUE / _SIZE, 0, 1000);
                Unity_Saturation_float(col.rgb, 1, col.rgb);
                return col;
            }
            ENDCG
        }
    }
}
