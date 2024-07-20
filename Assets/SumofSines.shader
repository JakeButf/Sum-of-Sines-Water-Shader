Shader "Custom/SumofSines"
{
    //Amplitude * sin(Direction * (x, y) * frequency + time * speed)
    Properties
    {

        _Amplitude ("Amplitude", Range(0,1)) = 0.5
        _Speed ("Speed", Range(0, 100)) = 2
        _Wavelength ("Wavelength", Range(0, 100)) = 1
        _Direction ("Direction", Vector) = (0, 0, 0, 0)

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
            float2 _Direction;

            //Vertex Calculations
            v2f vert(appdata v)
            {
                v2f o;
                //Sum of Sines Displacement
                float frequency = (2 * 3.14) / _Wavelength;
                float timeFactor = _Time * (_Speed * frequency);
                float2 direction = dot(_Direction, float2(v.vertex.x, v.vertex.z));

                float displacement1 = _Amplitude * sin(timeFactor + frequency *.25 * direction);
                float displacement2 = _Amplitude * sin(timeFactor + frequency * .5 * direction);
                float displacement3 = _Amplitude * sin(timeFactor + frequency * 1 * direction);


                float sumofsines = displacement1;

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
