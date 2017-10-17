Shader "Custom/Lookup" {
	Properties{
		[PerRendererData]_MainTex("Base (RGB)", 2D) = "white" {}
		_LookupMask("Lookup (A)", 2D) = "white" {}
	}
		SubShader{
		Tags{ "RenderType" = "Transparent" "Queue" = "Transparent" }
		Cull Off
		LOD 200
		Lighting off
		ZWrite off
		Pass
		{
			CGPROGRAM
			#pragma vertex vert_img
			#pragma fragment frag

			#include "UnityCG.cginc"

			uniform sampler2D _MainTex;
			uniform sampler2D _LookupMask;
#define DIM 8.0
			static const float divDim = float(1/DIM);
			static const float squareDim = float((DIM*DIM));
			static const float cubeDim = float((DIM*DIM*DIM));
			float fract(float v)
			{
				float fv = floor(v);
				return v - fv;
			}

			float3 lut(float3 textureColor)
			{
				textureColor.y = 1 - textureColor.y;
				textureColor.z = 1 - textureColor.z;
				float blueColor = textureColor.b * (squareDim-1);

				float2 quad1;
				quad1.y = floor(floor(blueColor) * divDim);
				quad1.x = floor(blueColor) - (quad1.y * DIM);

				float2 quad2;
				quad2.y = floor(ceil(blueColor) * divDim);
				quad2.x = ceil(blueColor) - (quad2.y * DIM);

				float2 texPos1;
				texPos1.x = (quad1.x * divDim) + 0.5 / cubeDim + ((divDim - 1.0 / cubeDim) * textureColor.r);
				texPos1.y = (quad1.y * divDim) + 0.5 / cubeDim + ((divDim - 1.0 / cubeDim) * textureColor.g);

				float2 texPos2;
				texPos2.x = (quad2.x * divDim) + 0.5 / cubeDim + ((divDim - 1.0 / cubeDim) * textureColor.r);
				texPos2.y = (quad2.y * divDim) + 0.5 / cubeDim + ((divDim - 1.0 / cubeDim) * textureColor.g);

				fixed4 newColor1 = tex2D(_LookupMask, texPos1);
				fixed4 newColor2 = tex2D(_LookupMask, texPos2);

				fixed4 newColor= lerp(newColor1, newColor2, fract(blueColor));
				return newColor.rgb;// lerp(textureColor, fixed4(newColor.rgb, textureColor.w), 0.0f);
			}


			fixed4 frag(v2f_img i) : SV_Target
			{
				fixed4 color = tex2D(_MainTex, i.uv);
				color.rgb = lut(color.rgb);
				return color;
			}
			ENDCG
		}
	}
	FallBack "Diffuse"
}
