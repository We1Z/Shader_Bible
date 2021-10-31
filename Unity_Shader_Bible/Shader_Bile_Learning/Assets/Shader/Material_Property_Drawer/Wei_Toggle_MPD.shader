Shader "Unlit/Wei_Toggle_Property"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        //Material Property Drawer
        // To date there are seven different drawers (Toggle;Enum;KeywordEnum;PowerSlider;IntRange;Space;Header)

        //MPD Toggle (mostly used as boolean)
        //[Toggle] _PropertyName ("Display Name", Float) = 0
        [Toggle] _Enable ("Enable ? ", Float) = 0

    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog
            #pragma multi_shader_feature _Enable_ON

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _Color;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                half4 col = tex2D(_MainTex, i.uv);
                //generate condition
                #if _Enable_ON
                    return col;
                #else
                    return col*_Color;
                #endif
            }
            ENDCG
        }
    }
}
