Shader "Custom/Blend" {
	Properties{
		[PerRendererData]	_MainTex("MainTex", 2D) = "white" {}
		_BlendTex("TopBendTex", 2D) = "white" {}
		_LookupTex("LookupTex", 2D) = "white" {}

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
		uniform sampler2D _BlendTex;
		uniform sampler2D _LookupTex;

		float fract(float v)
		{
			float fv = floor(v);
			return v - fv;
		}

		float3 blendBylut(float3 top, float3 bottom)
		{
			float3 ret;
			ret.r = tex2D(_LookupTex, float2( top.r, bottom.r)).r;
			ret.g = tex2D(_LookupTex, float2(top.g,  bottom.g)).r;
			ret.b = tex2D(_LookupTex, float2(top.b,  bottom.b)).r;

			return ret;
		}

		fixed4 frag(v2f_img i) : SV_Target
		{
			fixed4 bottom = tex2D(_MainTex, i.uv);
			fixed4 top = tex2D(_BlendTex, i.uv);
			top.rgb=   blendBylut(top.rgb, bottom.rgb);
			return top;
		}
			ENDCG
		}
	}
}
