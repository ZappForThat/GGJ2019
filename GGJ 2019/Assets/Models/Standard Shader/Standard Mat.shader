// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "GGJ/Standard"
{
	Properties
	{
		_TopColor("Top Color", Color) = (0.8949356,0,1,0)
		_LightmapTexScale("Lightmap Tex Scale", Float) = 0.5
		_BottomColor("Bottom Color", Color) = (0.1703008,0.8396226,0.1726939,0)
		_AOAmount("AO Amount", Range( 0 , 1)) = 0
		_SketchTex("SketchTex", 2D) = "white" {}
		[Toggle]_LightmapUVs("Lightmap UVs", Float) = 0
		_IgnoreShadow("Ignore Shadow", Range( 0 , 1)) = 0
		_GradientBalance("Gradient Balance", Range( -1 , 1)) = 0
		_GradientFalloff("Gradient Falloff", Range( 0 , 11)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] _texcoord2( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IgnoreProjector" = "True" }
		Cull Back
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "UnityCG.cginc"
		#include "UnityShaderVariables.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
			float4 vertexColor : COLOR;
			float2 uv2_texcoord2;
			float3 worldNormal;
		};

		struct SurfaceOutputCustomLightingCustom
		{
			half3 Albedo;
			half3 Normal;
			half3 Emission;
			half Metallic;
			half Smoothness;
			half Occlusion;
			half Alpha;
			Input SurfInput;
			UnityGIInput GIData;
		};

		uniform float4 _BottomColor;
		uniform float4 _TopColor;
		uniform float _GradientBalance;
		uniform float _GradientFalloff;
		uniform sampler2D _SketchTex;
		uniform float _LightmapUVs;
		uniform float _IgnoreShadow;
		uniform float _AOAmount;
		uniform float _LightmapTexScale;

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			#ifdef UNITY_PASS_FORWARDBASE
			float ase_lightAtten = data.atten;
			if( _LightColor0.a == 0)
			ase_lightAtten = 0;
			#else
			float3 ase_lightAttenRGB = gi.light.color / ( ( _LightColor0.rgb ) + 0.000001 );
			float ase_lightAtten = max( max( ase_lightAttenRGB.r, ase_lightAttenRGB.g ), ase_lightAttenRGB.b );
			#endif
			#if defined(HANDLE_SHADOWS_BLENDING_IN_GI)
			half bakedAtten = UnitySampleBakedOcclusion(data.lightmapUV.xy, data.worldPos);
			float zDist = dot(_WorldSpaceCameraPos - data.worldPos, UNITY_MATRIX_V[2].xyz);
			float fadeDist = UnityComputeShadowFadeDistance(data.worldPos, zDist);
			ase_lightAtten = UnityMixRealtimeAndBakedShadows(data.atten, bakedAtten, UnityComputeShadowFade(fadeDist));
			#endif
			float4 color274 = IsGammaSpace() ? float4(0.1215686,0.2666667,0.5686275,1) : float4(0.01370208,0.05780543,0.2831488,1);
			float clampResult7_g1 = clamp( ( i.uv_texcoord.y + _GradientBalance ) , 0.0 , 1.0 );
			float clampResult12_g1 = clamp( pow( clampResult7_g1 , exp2( _GradientFalloff ) ) , 0.0 , 1.0 );
			float temp_output_351_0 = clampResult12_g1;
			float4 lerpResult101 = lerp( _BottomColor , _TopColor , temp_output_351_0);
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float4 unityObjectToClipPos12 = UnityObjectToClipPos( ase_vertex3Pos );
			float4 computeScreenPos10 = ComputeScreenPos( unityObjectToClipPos12 );
			float4 unityObjectToClipPos14 = UnityObjectToClipPos( float3(0,0,0) );
			float4 computeScreenPos15 = ComputeScreenPos( unityObjectToClipPos14 );
			float4 transform26 = mul(unity_ObjectToWorld,float4( 0,0,0,1 ));
			float StandardUVGradient354 = temp_output_351_0;
			float clampResult330 = clamp( ( ase_lightAtten + ( StandardUVGradient354 * _IgnoreShadow ) ) , 0.0 , 1.0 );
			float clampResult94 = clamp( ( i.vertexColor.r + ( 1.0 - _AOAmount ) ) , 0.0 , 1.0 );
			float temp_output_290_0 = ( clampResult330 * clampResult94 );
			float shadowMask295 = temp_output_290_0;
			float lerpResult310 = lerp( 0.3 , ( 0.3 * 0.95 ) , shadowMask295);
			float2 appendResult56 = (float2(lerpResult310 , ( lerpResult310 / ( _ScreenParams.x / _ScreenParams.y ) )));
			float lerpResult322 = lerp( _LightmapTexScale , ( _LightmapTexScale * 0.95 ) , shadowMask295);
			float2 ScreenUVs217 = ( lerp(( (( ( ( computeScreenPos10 / (computeScreenPos10).w ) - ( computeScreenPos15 / (computeScreenPos15).w ) ) * distance( ( float4( _WorldSpaceCameraPos , 0.0 ) - transform26 ) , float4( 0,0,0,0 ) ) )).xy * appendResult56 ),( i.uv2_texcoord2 * lerpResult322 ),_LightmapUVs) + float2( 0,0 ) );
			float2 UVStep131 = ScreenUVs217;
			float3 ase_worldNormal = i.worldNormal;
			float3 ase_normWorldNormal = normalize( ase_worldNormal );
			float3 ase_worldPos = i.worldPos;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float dotResult105 = dot( ase_normWorldNormal , ase_worldlightDir );
			float clampResult212 = clamp( ( (0.0 + (dotResult105 - -1.0) * (1.0 - 0.0) / (1.0 - -1.0)) + -0.02 ) , 0.0 , 1.0 );
			float clampResult216 = clamp( pow( clampResult212 , exp2( 1.05 ) ) , 0.0 , 1.0 );
			float ShadowDot113 = clampResult216;
			float AO313 = clampResult94;
			float lerpResult292 = lerp( 0.0 , 5.0 , ( ShadowDot113 * AO313 ));
			float myVarName289 = temp_output_290_0;
			float clampResult174 = clamp( ( myVarName289 + -0.75 ) , 0.0 , 1.0 );
			float clampResult169 = clamp( ( tex2Dlod( _SketchTex, float4( UVStep131, 0, lerpResult292) ).r + clampResult174 ) , 0.0 , 1.0 );
			float2 _Vector1 = float2(0.5,0.5);
			float cos114 = cos( ( 0.25 * 6.28318548202515 ) );
			float sin114 = sin( ( 0.25 * 6.28318548202515 ) );
			float2 rotator114 = mul( ScreenUVs217 - _Vector1 , float2x2( cos114 , -sin114 , sin114 , cos114 )) + _Vector1;
			float2 UVStep2120 = rotator114;
			float clampResult178 = clamp( ( myVarName289 + -0.5 ) , 0.0 , 1.0 );
			float clampResult172 = clamp( ( tex2Dlod( _SketchTex, float4( UVStep2120, 0, lerpResult292) ).r + clampResult178 ) , 0.0 , 1.0 );
			float2 temp_output_185_0 = ( 1.33 * ScreenUVs217 );
			float cos184 = cos( ( 0.125 * 6.28318548202515 ) );
			float sin184 = sin( ( 0.125 * 6.28318548202515 ) );
			float2 rotator184 = mul( temp_output_185_0 - _Vector1 , float2x2( cos184 , -sin184 , sin184 , cos184 )) + _Vector1;
			float2 UVStep3191 = rotator184;
			float clampResult180 = clamp( ( myVarName289 + -0.25 ) , 0.0 , 1.0 );
			float clampResult196 = clamp( ( tex2Dlod( _SketchTex, float4( UVStep3191, 0, lerpResult292) ).r + clampResult180 ) , 0.0 , 1.0 );
			float cos197 = cos( ( -0.125 * 6.28318548202515 ) );
			float sin197 = sin( ( -0.125 * 6.28318548202515 ) );
			float2 rotator197 = mul( temp_output_185_0 - _Vector1 , float2x2( cos197 , -sin197 , sin197 , cos197 )) + _Vector1;
			float2 UVStep3B200 = rotator197;
			float clampResult204 = clamp( ( tex2Dlod( _SketchTex, float4( UVStep3B200, 0, lerpResult292) ).r + clampResult180 ) , 0.0 , 1.0 );
			float clampResult147 = clamp( ( clampResult169 * ( clampResult172 * clampResult172 ) * ( clampResult196 * clampResult196 * clampResult204 * clampResult204 ) ) , 0.0 , 1.0 );
			float SketchMask283 = clampResult147;
			float clampResult344 = clamp( ( SketchMask283 + ( 1.0 - 0.7176471 ) ) , 0.0 , 1.0 );
			float clampResult298 = clamp( ( shadowMask295 + ( 1.0 - 0.98 ) ) , 0.0 , 1.0 );
			float temp_output_296_0 = ( clampResult344 * clampResult298 );
			float4 lerpResult272 = lerp( color274 , lerpResult101 , temp_output_296_0);
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			float4 temp_output_315_0 = ( temp_output_296_0 * ase_lightColor );
			c.rgb = ( lerpResult272 + temp_output_315_0 ).rgb;
			c.a = 1;
			return c;
		}

		inline void LightingStandardCustomLighting_GI( inout SurfaceOutputCustomLightingCustom s, UnityGIInput data, inout UnityGI gi )
		{
			s.GIData = data;
		}

		void surf( Input i , inout SurfaceOutputCustomLightingCustom o )
		{
			o.SurfInput = i;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardCustomLighting keepalpha fullforwardshadows 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float4 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				float3 worldNormal : TEXCOORD3;
				half4 color : COLOR0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.worldNormal = worldNormal;
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.customPack1.zw = customInputData.uv2_texcoord2;
				o.customPack1.zw = v.texcoord1;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				o.color = v.color;
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				surfIN.uv2_texcoord2 = IN.customPack1.zw;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = IN.worldNormal;
				surfIN.vertexColor = IN.color;
				SurfaceOutputCustomLightingCustom o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputCustomLightingCustom, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16200
0.5714286;672;1055;482;4112.984;578.1763;1;True;False
Node;AmplifyShaderEditor.RangedFloatNode;352;1248.777,-52.12527;Float;False;Property;_GradientBalance;Gradient Balance;10;0;Create;True;0;0;False;0;0;0;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;353;1243.421,37.63303;Float;False;Property;_GradientFalloff;Gradient Falloff;11;0;Create;True;0;0;False;0;0;0;0;11;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;103;1289.195,-212.7909;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;351;1590.995,-178.9346;Float;False;F_Balance and Falloff;-1;;1;db63d5e8967e8734489214297d7545f6;0;3;1;FLOAT;0;False;3;FLOAT;0;False;10;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;354;1882.68,-117.037;Float;False;StandardUVGradient;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;96;-3723.342,48.05357;Float;False;Property;_AOAmount;AO Amount;6;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;355;-3757.984,-422.1763;Float;False;354;StandardUVGradient;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;329;-3776.393,-274.1387;Float;False;Property;_IgnoreShadow;Ignore Shadow;9;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;104;-3455.374,54.56199;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;89;-3448.638,-115.489;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LightAttenuation;285;-3537.631,-562.3117;Float;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;328;-3452.969,-397.7413;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;93;-3255.542,-93.84619;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;326;-3236.645,-401.875;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;11;-3388.316,-2370.008;Float;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector3Node;13;-3386.316,-2142.007;Float;False;Constant;_Vector0;Vector 0;0;0;Create;True;0;0;False;0;0,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.UnityObjToClipPosHlpNode;12;-3160.318,-2365.008;Float;False;1;0;FLOAT3;0,0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;94;-3091.741,-193.9463;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;330;-3070.807,-403.3251;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.UnityObjToClipPosHlpNode;14;-3182.318,-2128.007;Float;False;1;0;FLOAT3;0,0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;290;-2894.317,-336.3914;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComputeScreenPosHlpNode;10;-2971.859,-2364.594;Float;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ComputeScreenPosHlpNode;15;-2997.318,-2117.007;Float;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;24;-2824.337,-1632.995;Float;False;Constant;_TexScale;Tex Scale;0;0;Create;True;0;0;False;0;0.3;6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;295;-2708.051,-274.1289;Float;False;shadowMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceCameraPos;25;-2604.641,-1963.25;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;26;-2517.846,-1796.083;Float;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;312;-2776.857,-1387.438;Float;False;Constant;_Float8;Float 8;8;0;Create;True;0;0;False;0;0.95;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;16;-2744.318,-2082.007;Float;False;False;False;False;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;17;-2762.745,-2253.076;Float;False;False;False;False;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;27;-2246.845,-1909.083;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;19;-2469.731,-2161.343;Float;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ScreenParams;61;-2354.617,-1260.953;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;308;-2766.16,-1074.602;Float;False;295;shadowMask;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;18;-2471.731,-2359.343;Float;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;311;-2585.857,-1451.438;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;28;-2002.846,-1944.083;Float;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;310;-2388.461,-1462.688;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;62;-2174.749,-1273.482;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;324;-1635.297,-1373.078;Float;False;Property;_LightmapTexScale;Lightmap Tex Scale;1;0;Create;True;0;0;False;0;0.5;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;20;-2045.731,-2265.343;Float;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;108;-519.6608,-3521.787;Float;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldNormalVector;106;-472.4299,-3669.268;Float;False;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;325;-1393.184,-1282.239;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;63;-2168.551,-1378.815;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;105;-199.5306,-3673.128;Float;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;-1773.846,-2107.083;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ComponentMaskNode;35;-1623.375,-2116.16;Float;False;True;True;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TFHCRemapNode;137;26.82317,-3666.042;Float;False;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;211;57.86459,-3469.515;Float;False;Constant;_LightBalance;Light Balance;8;0;Create;True;0;0;False;0;-0.02;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;56;-2057.264,-1525.631;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;318;-1280.285,-1469.501;Float;False;1;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;322;-1216.062,-1308.63;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;320;-971.6802,-1344.347;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;215;291.8646,-3396.515;Float;False;Constant;_LightFalloff;Light Falloff;8;0;Create;True;0;0;False;0;1.05;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;210;276.8646,-3581.515;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;55;-1063.834,-1947.832;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Exp2OpNode;214;488.8646,-3425.515;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;212;412.8646,-3569.515;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;319;-447.2234,-1967.012;Float;False;Property;_LightmapUVs;Lightmap UVs;8;0;Create;True;0;0;False;0;0;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;238;-238.2884,-2137.021;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PowerNode;213;600.8646,-3547.515;Float;True;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;117;150.9986,-1844.4;Float;False;Constant;_Float1;Float 1;9;0;Create;True;0;0;False;0;0.25;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;217;-83.98399,-2143.456;Float;False;ScreenUVs;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TauNode;115;183.9986,-1764.4;Float;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;199;273.8645,-2132.36;Float;False;Constant;_Float7;Float 7;9;0;Create;True;0;0;False;0;-0.125;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;189;301.828,-2297.839;Float;False;Constant;_Float6;Float 6;9;0;Create;True;0;0;False;0;0.125;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;186;-113.8177,-2353.957;Float;False;Constant;_Float5;Float 5;8;0;Create;True;0;0;False;0;1.33;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;216;882.8646,-3535.515;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TauNode;188;365.1949,-2212.055;Float;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;313;-2838.307,-170.923;Float;False;AO;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;119;254.2492,-1975.933;Float;False;Constant;_Vector1;Vector 1;9;0;Create;True;0;0;False;0;0.5,0.5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;185;92.87315,-2328.101;Float;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;190;483.1948,-2286.055;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;116;301.9986,-1838.4;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;113;1063.499,-3530.646;Float;False;ShadowDot;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;198;551.5034,-2133.806;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RotatorNode;197;712.4392,-2330.331;Float;True;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;304;-2242.479,584.7063;Float;False;313;AO;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;182;914.4888,-2038.252;Float;False;296.2857;164.7142;Comment;1;120;UV Step 2;1,1,1,1;0;0
Node;AmplifyShaderEditor.TexturePropertyNode;121;2504.084,-926.1227;Float;True;Property;_SketchTex;SketchTex;7;0;Create;True;0;0;False;0;None;359c415136f8e364dbf2efd32a4477f7;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.CommentaryNode;192;939.3242,-2655.401;Float;False;336.2857;316.7144;Comment;2;191;200;UV Step 3;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;294;-2249.99,472.9056;Float;False;113;ShadowDot;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RotatorNode;184;609.5204,-2566.514;Float;True;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RotatorNode;114;644.9478,-1954.816;Float;True;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;291;-2070.914,328.1794;Float;False;Constant;_MipLevel;Mip Level;8;0;Create;True;0;0;False;0;5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;289;-2728.8,-396.6733;Float;False;myVarName;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;177;-2331.959,-138.9583;Float;False;Constant;_Float3;Float 3;8;0;Create;True;0;0;False;0;-0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;183;950.2703,-1566.875;Float;False;296.2857;164.7142;Comment;1;31;UV Step 1;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;181;-2331.641,93.67621;Float;False;Constant;_Float4;Float 4;8;0;Create;True;0;0;False;0;-0.25;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;293;-2055.305,252.9261;Float;False;Constant;_Float0;Float 0;8;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;122;2766.389,-930.7224;Float;False;SketchTex;-1;True;1;0;SAMPLER2D;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;305;-2041.266,470.1493;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;200;985.3545,-2465.998;Float;False;UVStep3B;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;191;989.3242,-2605.401;Float;False;UVStep3;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;120;964.4888,-1988.252;Float;False;UVStep2;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;31;1000.27,-1516.875;Float;False;UVStep1;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;125;-1679.03,-85.15205;Float;False;120;UVStep2;1;0;OBJECT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;175;-2337.298,-354.6792;Float;False;Constant;_Float2;Float 2;8;0;Create;True;0;0;False;0;-0.75;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;194;-1641.298,143.6112;Float;False;191;UVStep3;1;0;OBJECT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;202;-1636.117,250.4394;Float;False;200;UVStep3B;1;0;OBJECT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;123;-1656.402,-537.3752;Float;False;122;SketchTex;1;0;OBJECT;0;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SimpleAddOpNode;176;-2312.569,-265.2401;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;292;-1812.305,279.9261;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;179;-2312.251,-32.60561;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;193;-1400.344,143.6112;Float;True;Property;_TextureSample1;Texture Sample 1;1;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;MipLevel;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;180;-2132.641,-10.3238;Float;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;124;-1442.9,-102.3071;Float;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;MipLevel;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;173;-2325.801,-458.1501;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;178;-2132.959,-242.9583;Float;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;32;-1683.356,-444.2319;Float;False;31;UVStep1;1;0;OBJECT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;201;-1386.035,364.85;Float;True;Property;_TextureSample2;Texture Sample 2;1;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;MipLevel;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;170;-945.1322,-251.5912;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;195;-958.2195,33.04131;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;30;-1425.578,-532.128;Float;True;Property;_ScreenSpaceTex;Screen Space Tex;1;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;MipLevel;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;203;-944.1894,223.7256;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;174;-2128.713,-462.4349;Float;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;204;-782.2946,226.5256;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;172;-780.9121,-246.4294;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;196;-790.1341,16.29928;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;168;-939.1567,-444.6071;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;209;-533.4355,24.90656;Float;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;206;-617.1635,-249.7918;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;169;-769.8971,-440.716;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;171;-418.4232,-431.1041;Float;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;147;-59.03701,-436.0345;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;300;1522.9,473.9999;Float;False;Constant;_ShadowFillAmount;Shadow Fill Amount;8;0;Create;True;0;0;False;0;0.98;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;342;1536.501,234.2143;Float;False;Constant;_SketchFillAmount;Sketch Fill Amount;10;0;Create;True;0;0;False;0;0.7176471;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;283;142.1609,-426.02;Float;False;SketchMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;301;1808.9,472.9999;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;343;1884.501,248.2143;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;288;1723.958,150.3508;Float;False;283;SketchMask;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;297;1792.9,350.9999;Float;False;295;shadowMask;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;341;2033.501,178.2143;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;299;2008.899,368.9999;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;344;2190.501,174.2143;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;102;1745.453,-552.2416;Float;False;Property;_BottomColor;Bottom Color;2;0;Create;True;0;0;False;0;0.1703008,0.8396226,0.1726939,0;0.7830188,0.7217219,0.6685208,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;40;1774.948,-369.7809;Float;False;Property;_TopColor;Top Color;0;0;Create;True;0;0;False;0;0.8949356,0,1,0;1,0.9295731,0.6462264,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;298;2210.899,332.9999;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;101;2139.938,-202.9486;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LightColorNode;314;2645.702,220.8104;Float;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;296;2330.899,228.9999;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;274;2200.74,-421.6306;Float;False;Constant;_ShadowColor;Shadow Color;9;0;Create;True;0;0;False;0;0.1215686,0.2666667,0.5686275,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;272;2642.647,-318.4952;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;315;2746.554,5.313453;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;76;-582.3019,-3129.363;Float;False;World;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;208;-802.84,145.5985;Float;False;Constant;_Float9;Float 9;8;0;Create;True;0;0;False;0;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;222;-2072.396,-3015.402;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;223;-2261.396,-2886.402;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;79;613.8567,-3188.848;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RoundOpNode;225;-1678.96,-2975.127;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;75;-570.4189,-3263.549;Float;False;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RegisterLocalVarNode;331;-1361.082,-2968.721;Float;False;Toggle;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;221;-2441.027,-2969.982;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;78;480.1245,-3044.965;Float;False;Property;_FresnelAmount;Fresnel Amount;5;0;Create;True;0;0;False;0;0.5;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;77;786.1244,-3188.965;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;239;-1872.133,-2988.582;Float;False;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;224;-2443.396,-2892.402;Float;False;Constant;_Float11;Float 11;9;0;Create;True;0;0;False;0;14;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;67;-89.24187,-3202.385;Float;True;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;69;969.061,-3196.091;Float;False;Fresnel;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;350;2998.756,-257.8932;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;71;-77.88573,-2889.574;Float;False;Property;_FresnelFalloff;Fresnel Falloff;4;0;Create;True;0;0;False;0;0;0;0;11;0;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;64;-222.4848,-3204.211;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;68;297.1366,-3191.694;Float;False;F_Balance and Falloff;-1;;1;db63d5e8967e8734489214297d7545f6;0;3;1;FLOAT;0;False;3;FLOAT;0;False;10;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;97;-93.23876,-2995.861;Float;False;Property;_FresnelBalance;Fresnel Balance;3;0;Create;True;0;0;False;0;0;-1;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;349;2979.93,61.30035;Float;False;5;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;3;COLOR;0.5,0.5,0.5,0;False;4;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;3218.044,-435.6179;Float;False;True;2;Float;ASEMaterialInspector;0;0;CustomLighting;GGJ/Standard;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;351;1;103;2
WireConnection;351;3;352;0
WireConnection;351;10;353;0
WireConnection;354;0;351;0
WireConnection;104;0;96;0
WireConnection;328;0;355;0
WireConnection;328;1;329;0
WireConnection;93;0;89;1
WireConnection;93;1;104;0
WireConnection;326;0;285;0
WireConnection;326;1;328;0
WireConnection;12;0;11;0
WireConnection;94;0;93;0
WireConnection;330;0;326;0
WireConnection;14;0;13;0
WireConnection;290;0;330;0
WireConnection;290;1;94;0
WireConnection;10;0;12;0
WireConnection;15;0;14;0
WireConnection;295;0;290;0
WireConnection;16;0;15;0
WireConnection;17;0;10;0
WireConnection;27;0;25;0
WireConnection;27;1;26;0
WireConnection;19;0;15;0
WireConnection;19;1;16;0
WireConnection;18;0;10;0
WireConnection;18;1;17;0
WireConnection;311;0;24;0
WireConnection;311;1;312;0
WireConnection;28;0;27;0
WireConnection;310;0;24;0
WireConnection;310;1;311;0
WireConnection;310;2;308;0
WireConnection;62;0;61;1
WireConnection;62;1;61;2
WireConnection;20;0;18;0
WireConnection;20;1;19;0
WireConnection;325;0;324;0
WireConnection;325;1;312;0
WireConnection;63;0;310;0
WireConnection;63;1;62;0
WireConnection;105;0;106;0
WireConnection;105;1;108;0
WireConnection;29;0;20;0
WireConnection;29;1;28;0
WireConnection;35;0;29;0
WireConnection;137;0;105;0
WireConnection;56;0;310;0
WireConnection;56;1;63;0
WireConnection;322;0;324;0
WireConnection;322;1;325;0
WireConnection;322;2;308;0
WireConnection;320;0;318;0
WireConnection;320;1;322;0
WireConnection;210;0;137;0
WireConnection;210;1;211;0
WireConnection;55;0;35;0
WireConnection;55;1;56;0
WireConnection;214;0;215;0
WireConnection;212;0;210;0
WireConnection;319;0;55;0
WireConnection;319;1;320;0
WireConnection;238;0;319;0
WireConnection;213;0;212;0
WireConnection;213;1;214;0
WireConnection;217;0;238;0
WireConnection;216;0;213;0
WireConnection;313;0;94;0
WireConnection;185;0;186;0
WireConnection;185;1;217;0
WireConnection;190;0;189;0
WireConnection;190;1;188;0
WireConnection;116;0;117;0
WireConnection;116;1;115;0
WireConnection;113;0;216;0
WireConnection;198;0;199;0
WireConnection;198;1;188;0
WireConnection;197;0;185;0
WireConnection;197;1;119;0
WireConnection;197;2;198;0
WireConnection;184;0;185;0
WireConnection;184;1;119;0
WireConnection;184;2;190;0
WireConnection;114;0;217;0
WireConnection;114;1;119;0
WireConnection;114;2;116;0
WireConnection;289;0;290;0
WireConnection;122;0;121;0
WireConnection;305;0;294;0
WireConnection;305;1;304;0
WireConnection;200;0;197;0
WireConnection;191;0;184;0
WireConnection;120;0;114;0
WireConnection;31;0;217;0
WireConnection;176;0;289;0
WireConnection;176;1;177;0
WireConnection;292;0;293;0
WireConnection;292;1;291;0
WireConnection;292;2;305;0
WireConnection;179;0;289;0
WireConnection;179;1;181;0
WireConnection;193;0;123;0
WireConnection;193;1;194;0
WireConnection;193;2;292;0
WireConnection;180;0;179;0
WireConnection;124;0;123;0
WireConnection;124;1;125;0
WireConnection;124;2;292;0
WireConnection;173;0;289;0
WireConnection;173;1;175;0
WireConnection;178;0;176;0
WireConnection;201;0;123;0
WireConnection;201;1;202;0
WireConnection;201;2;292;0
WireConnection;170;0;124;1
WireConnection;170;1;178;0
WireConnection;195;0;193;1
WireConnection;195;1;180;0
WireConnection;30;0;123;0
WireConnection;30;1;32;0
WireConnection;30;2;292;0
WireConnection;203;0;201;1
WireConnection;203;1;180;0
WireConnection;174;0;173;0
WireConnection;204;0;203;0
WireConnection;172;0;170;0
WireConnection;196;0;195;0
WireConnection;168;0;30;1
WireConnection;168;1;174;0
WireConnection;209;0;196;0
WireConnection;209;1;196;0
WireConnection;209;2;204;0
WireConnection;209;3;204;0
WireConnection;206;0;172;0
WireConnection;206;1;172;0
WireConnection;169;0;168;0
WireConnection;171;0;169;0
WireConnection;171;1;206;0
WireConnection;171;2;209;0
WireConnection;147;0;171;0
WireConnection;283;0;147;0
WireConnection;301;0;300;0
WireConnection;343;0;342;0
WireConnection;341;0;288;0
WireConnection;341;1;343;0
WireConnection;299;0;297;0
WireConnection;299;1;301;0
WireConnection;344;0;341;0
WireConnection;298;0;299;0
WireConnection;101;0;102;0
WireConnection;101;1;40;0
WireConnection;101;2;351;0
WireConnection;296;0;344;0
WireConnection;296;1;298;0
WireConnection;272;0;274;0
WireConnection;272;1;101;0
WireConnection;272;2;296;0
WireConnection;315;0;296;0
WireConnection;315;1;314;0
WireConnection;222;0;223;0
WireConnection;223;0;221;0
WireConnection;223;1;224;0
WireConnection;79;0;68;0
WireConnection;225;0;239;0
WireConnection;331;0;225;0
WireConnection;77;0;79;0
WireConnection;77;1;78;0
WireConnection;239;0;222;0
WireConnection;67;0;64;0
WireConnection;69;0;77;0
WireConnection;350;0;272;0
WireConnection;350;1;315;0
WireConnection;64;0;75;0
WireConnection;64;1;76;0
WireConnection;68;1;67;0
WireConnection;68;3;97;0
WireConnection;68;10;71;0
WireConnection;349;0;315;0
WireConnection;0;13;350;0
ASEEND*/
//CHKSM=5A17B8BF27E397D6363B777C5FE1F948236E1868