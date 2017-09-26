Shader "Custom/VertexColor" {
	Properties{
		_PointSize("PointSize", Float) = 5
	}
		SubShader{
		Tags{ "Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent" }
		LOD 200
		Pass{
		Cull Off ZWrite On Blend SrcAlpha OneMinusSrcAlpha


		CGPROGRAM
#pragma exclude_renderers flash
#pragma vertex vert
#pragma fragment frag

		struct VertexInput {
		float4 v : POSITION;
		float4 color: COLOR;
	};

	struct VertexOutput {
		float4 pos : SV_POSITION;
		float size : PSIZE;
		float4 col : COLOR;
	};
	float _PointSize;

	VertexOutput vert(VertexInput v) {

		VertexOutput o;
		o.pos = mul(UNITY_MATRIX_MVP, v.v);
		o.size = _PointSize;
		o.col = v.color;
		return o;
	}

	float4 frag(VertexOutput o) : COLOR{
		return o.col;
	}

		ENDCG
	}
	}

}
