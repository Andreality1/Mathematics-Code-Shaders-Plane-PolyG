Shader "Unlit/Shader_Graphics_TriangleRectangle_2_SDF_Plane"
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

                float2 uv =  i.uv ;

                float4 colorWhite = float4(1,1,1,1); // Color white.
                float4 colorBlack = float4(0,0,0,1); // Color Black.


                float2 coordinateScale = (uv * 2.0)  - 1.0;

                float2 size = float2(0.5 ,0.5);

                float2 screenSpace = coordinateScale;

                float disHypotenuse = dot(size, screenSpace ) - (size.x * size.y); 

                float sdf =  ( sign(disHypotenuse) < 0 && screenSpace.y > 0 && screenSpace.x > 0 ) ? 1.0 : 0.0 ;

                float shader = 0.0;

                if(sdf == 1.0)
                {
                
                    float shaderSmooth =  min(abs(disHypotenuse), min(screenSpace.x, screenSpace.y));

                    shader = shaderSmooth;

                    }

                float shaderOut =  smoothstep(0.0, 0.004, shader);

                float col = colorBlack;

                col = fixed4(shaderOut, shaderOut, shaderOut, 1.0);

                return col;

            }
    
            ENDCG
        }
    }
}
