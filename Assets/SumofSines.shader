Shader "Custom/SumofSines"
{
    //Amplitude * sin(Direction * (x, y) * frequency + time * speed)
    Properties
    {

        _Amplitude ("Amplitude", Range(0,1)) = 0.5
        _Speed ("Speed", Range(0, 100)) = 2
        _Wavelength ("Wavelength", Range(0, 100)) = 1

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

            //Vertex Input
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            //Vertex Output
            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex: SV_POSITION;
            };

            //Shader Properties
            float _Amplitude;
            float _Speed;
            float _Wavelength;

            //Vertex Calculations
            v2f vert(appdata v)
            {
                v2f o;
                //Sum of Sines Displacement
                float frequency = (2 * 3.14) / _Wavelength;
                float displacement1 = _Amplitude * sin((_Time * (_Speed * frequency)) + (frequency * 0.25 * v.vertex.x));
                float displacement2 = _Amplitude * sin((_Time * (_Speed * frequency)) + (frequency * 0.5 * v.vertex.x));
                float displacement3 = _Amplitude * sin((_Time * (_Speed * frequency)) + (frequency * 1 * v.vertex.x));

                float sumofsines = displacement1 + displacement2 + displacement3;

                //Apply displacement to vertex position
                o.vertex = UnityObjectToClipPos(v.vertex + float4(0, sumofsines, 0, 0)); //only displace y
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
