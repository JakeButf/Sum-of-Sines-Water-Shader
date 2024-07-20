Shader "Custom/SumofSines"
{
    //Amplitude * sin(Direction * (x, y) * frequency + time * speed)
    Properties
    {

        _Amplitude ("Amplitude", Range(0,1)) = 0.5
        _Wavelength ("Wavelength", Range(0.1, 10)) = 1
        _Speed ("Speed", Range(0, 100)) = 2

        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
    }
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex: SV_POSITION;
            };

            float _Amplitude;
            float _Wavelength;
            float _Speed;

            v2f vert(appdata v)
            {
                v2f o;
                float displacement = _Amplitude * sin(_Time * (_Speed * ((2 * 3.1415) / _Wavelength) + v.vertex.x));

                o.vertex = UnityObjectToClipPos(v.vertex + float4(0, displacement, 0, 0));
                o.uv = v.uv;

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                return fixed4(i.uv, 0, 1);
            }
            ENDCG
        }

    }
        
}
