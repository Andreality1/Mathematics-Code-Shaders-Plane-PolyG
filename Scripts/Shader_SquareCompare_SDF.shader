Shader "Unlit/Shader_Graphics_SquareCompare_SDF_Plane"
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




            fixed4 frag (PixelData i) : SV_Target
            {
                
                // THIS CODE MEANS
                // HOW TO RUN THE PIXELS OF THE SCREEN.

                float2 uv = i.uv;
                float2 coordinateScale = uv * 2.0 - 1.0;
            	coordinateScale = coordinateScale/(float2(0.55555, 1.0));

                float4 colorWhite = float4(1,1,1,1); // Color white.
                float4 colorBlack = float4(0,0,0,1); // Color Black.
                float Smoothing = 0.01;

                float2 size = float2(0.5, 0.5);
                float2 bounds = abs(coordinateScale);

                float4 col = colorBlack; 

                if ((bounds.x) <= size.x && (bounds.y) <= size.y  && bounds.x >= 0.0 && bounds.y >= 0.0)
                {

                    col = fixed4(1.0, 1.0, 1.0, 1.0);
                    
                }

                return col;

            }

            ENDCG
        }
    }
}
