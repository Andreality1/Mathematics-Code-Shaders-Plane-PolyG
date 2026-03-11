Shader "Unlit/Shader_Graphics_CircleSDF_Plane"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _StepTime ("Step Time", Float) = 0.0
    }
    SubShader
    {


        Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
        ZWrite Off
        Blend SrcAlpha OneMinusSrcAlpha
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert alpha
            #pragma fragment frag alpha

            #include "UnityCG.cginc"

            struct VertexInfo
            {
                float2 uv : TEXCOORD0;
                float4 vertex : POSITION;
            };

            struct PixelData
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            int _SetScreen ;
            float _StepTime; // This receives the value from C#


            PixelData vert (VertexInfo v)
            {
                PixelData o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }


            float smoothstepREFLECT(float a, float b, float x)
            {
                float check = (x - a )/(b - a );
                float check2 = max(0, min(1,check));
                check2 = check2 - 1;
                
                float result = 3.0 * check2 * check2 + 2.0 * check2 * check2 * check2;

                float putOut = result;
                return putOut;
            }

            fixed4 frag (PixelData i) : SV_Target
            {
                
                // THIS CODE MEANS
                // HOW TO RUN THE PIXELS OF THE SCREEN.
                
                float2 uv =  i.uv ;
                float4 col = float4(0,0,0,1);
                float4 red = float4(1,0,0,1);
                float4 white = float4(1,1,1,1);

                float2 toOneUV = uv;
        
            	float2 coordinateScale = (uv * 2.0)  - 1.0;
            	float2 coordinateShade = coordinateScale/(float2(0.55555, 1.0));

                float2 coor = coordinateShade;


                float radius = 0.5;
                float number = length(coor) - radius;
                   
                float smooth =  smoothstepREFLECT(0.0 , 0.01, number);                
                
                col = fixed4(smooth, 0.0, 0.0, 1.0);

                return col;


            }

            ENDCG
        }
    }
}
