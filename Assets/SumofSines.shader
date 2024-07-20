Shader "Custom/CartoonySumofSines"
{
    Properties
    {
        _Amplitude ("Amplitude", Range(0,10)) = 0.5
        _Speed ("Speed", Range(0, 100)) = 2
        _Wavelength ("Wavelength", Range(0, 100)) = 1
        _Direction ("Direction", Vector) = (0, 0, 0, 0)
        _Color1 ("Color 1", Color) = (1, 0, 0, 1)
        _Color2 ("Color 2", Color) = (0, 1, 0, 1)
        _EdgeColor ("Edge Color", Color) = (0, 0, 0, 1)
        _Threshold ("Threshold", Range(0, 1)) = 0.4
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 normal : TEXCOORD1;
                float sumofsines : TEXCOORD2;
            };

            float _Amplitude;
            float _Speed;
            float _Wavelength;
            float2 _Direction;
            float4 _Color1;
            float4 _Color2;
            float4 _EdgeColor;
            float _Threshold;

            v2f vert(appdata v)
            {
                v2f o;
                float frequency = (2 * 3.14) / _Wavelength;
                float timeFactor = _Time.y * (_Speed * frequency);
                float2 direction = dot(_Direction, float2(v.vertex.x, v.vertex.z));

                float displacement1 = _Amplitude * sin(timeFactor + frequency * .25 * direction);
                float displacement2 = _Amplitude * sin(timeFactor + frequency * .5 * direction);
                float displacement3 = _Amplitude * sin(timeFactor + frequency * 1 * direction);

                float sumofsines = displacement1 + displacement2 + displacement3;

                o.vertex = UnityObjectToClipPos(v.vertex + float4(0, sumofsines, 0, 0));
                o.uv = v.uv;
                o.normal = mul((float3x3)unity_WorldToObject, v.normal);
                o.sumofsines = sumofsines;

                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float intensity = dot(i.normal, normalize(float3(0, 1, 0)));
                intensity = floor(intensity / _Threshold) * _Threshold;

                float3 color = lerp(_Color1.rgb, _Color2.rgb, (sin(i.sumofsines) + 1.0) / 2.0);
                color *= intensity;

                float edge = smoothstep(0.0, 1.0, length(i.normal.xy));
                edge = 1.0 - edge;

                float4 finalColor = lerp(fixed4(color, 1.0), _EdgeColor, edge);
                return finalColor;
            }
            ENDCG
        }
    }
}
