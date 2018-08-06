// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

/*
1. 暴露一个输入
2. 顶点着色器，根据顶点法线计算一个颜色值
3. 片元着色器，使用输入的颜色来调和发现计算出来的颜色
*/

// 自定义名称
Shader "Custom/02" {
	Properties{
		_Color("Color tint", Color) = (1,1,1,1)
	}
	SubShader {
		Pass{
			CGPROGRAM

			// 定义顶点着色器  处理函数
			#pragma vertex vert
            // 定义片段着色器 处理函数
			#pragma fragment frag

			// uniform 是一种修辞，标识数据由外部应用程序初始化并传入
			// fixed4 理解为 4X1 的向量， fixed 的取值范围为 [-2,2] 一般用于定义 颜色、单位向量 这种有限值
			uniform fixed4 _Color;

			struct a2v {
				// float4 理解为 4X1 的向量， float 32位高精度浮点数
				// half：16位中精度浮点数。范围是[-6万, +6万]，能精确到十进制的小数点后3.3位。
				// POSITION  NORMAL 属于语义 
                // POSITION 表示将模型空间下的顶点坐标填充给vertex属性
                // NORMAL   表示将模型空间下的顶点法线填充给normal属性
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};

			struct v2f {
				// SV_POSITION 初步理解和POSITION基本一致，在DX10以后，一旦被作为vertex shader的输出语义，
                // 那么这个最终的顶点位置就被固定了，应该是为了性能优化
				float4 pos : SV_POSITION;
				fixed3 color : COLOR;
			};

			v2f vert (a2v v){
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.color = v.normal * 0.5 + fixed3(0.5, 0.5, 0.5);
				return o;
			}

			fixed4 frag (v2f i) : SV_target {
				fixed3 c = i.color;
				// 乘法 的效果是颜色的混合，这个乘法和向量的乘法含义不一样
                // 加法 的效果是颜色偏移
				c *= _Color.rgb;
				return fixed4(c, 1.0);
			}

			ENDCG
		}
	}
	// 默认处理
	FallBack "Diffuse"
}
