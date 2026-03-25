Shader "Unlit/Shader_Graphics_LineEquation_2_SDF_Plane"
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


            float sdLine(float2 p, float2 a, float2 b) {
                float2 pa = p - a;
                float2 ba = b - a;

                // Calculate the projection percentage (t) and clamp it [0, 1]
                float h = clamp(dot(pa, ba) / dot(ba, ba), 0.0, 1.0);

                // Return the distance from P to the projected point on the segment
                return length(pa - ba * h);
            }
            
            fixed4 frag (PixelData i) : SV_Target
            {
            
                float2 uv =  i.uv ;

                float4 colorWhite = float4(1,1,1,1); // Color white.
                float4 colorBlack = float4(0,0,0,1); // Color Black.


                float2 coordinateScale = (uv * 2.0)  - 1.0;

                // float2 size =  float2(sin(_Time.y) , sin(2*_Time.y)) ;
                float2 size = float2(0.1 , 0.1);
                // size = float2(max(size.x, 0.0001 ), size.y);

                float2 screenSpace = coordinateScale;

                float2 startLine = float2(-0.5, -0.5);    
                float2 endLine = float2(0.5, 0.5);    

                float sdfLine = sdLine(coordinateScale, startLine, endLine);

                float shader = 1.0 - smoothstep(0.0, 0.01, sdfLine);

                float4 col = colorBlack;

                col = fixed4(shader, shader, shader, 1.0);

                return col;
            }

            ENDCG
        }
    }
}
