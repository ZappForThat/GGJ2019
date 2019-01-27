// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "New Amplify Shader"
{
	Properties
	{
		_TexScale("Tex Scale", Float) = 1
		_ScreenSpaceTex("Screen Space Tex", 2D) = "white" {}
		_TopColor("Top Color", Color) = (0.8949356,0,1,0)
		_BottomColor("Bottom Color", Color) = (0.1703008,0.8396226,0.1726939,0)
		_FresnelBalance("Fresnel Balance", Range( -1 , 1)) = 0
		_FresnelFalloff("Fresnel Falloff", Range( 0 , 11)) = 0
		_FresnelAmount("Fresnel Amount", Range( 0 , 1)) = 0.5
		_AOAmount("AO Amount", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
			float3 worldNormal;
			float4 vertexColor : COLOR;
		};

		uniform float4 _BottomColor;
		uniform float4 _TopColor;
		uniform sampler2D _ScreenSpaceTex;
		uniform float _TexScale;
		uniform float _FresnelBalance;
		uniform float _FresnelFalloff;
		uniform float _FresnelAmount;
		uniform float _AOAmount;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 color91 = IsGammaSpace() ? float4(0.235944,0.1490196,0.5568628,0) : float4(0.04542937,0.01938236,0.2704979,0);
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			float4 lerpResult101 = lerp( _BottomColor , _TopColor , i.uv_texcoord.y);
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float4 unityObjectToClipPos12 = UnityObjectToClipPos( ase_vertex3Pos );
			float4 computeScreenPos10 = ComputeScreenPos( unityObjectToClipPos12 );
			float4 temp_output_18_0 = ( computeScreenPos10 / (computeScreenPos10).w );
			float4 unityObjectToClipPos14 = UnityObjectToClipPos( float3(0,0,0) );
			float4 computeScreenPos15 = ComputeScreenPos( unityObjectToClipPos14 );
			float4 temp_output_19_0 = ( computeScreenPos15 / (computeScreenPos15).w );
			float4 transform26 = mul(unity_ObjectToWorld,float4( 0,0,0,1 ));
			float temp_output_28_0 = distance( ( float4( _WorldSpaceCameraPos , 0.0 ) - transform26 ) , float4( 0,0,0,0 ) );
			float2 appendResult56 = (float2(_TexScale , ( _TexScale / ( _ScreenParams.x / _ScreenParams.y ) )));
			float2 ScreenSpaceUVs31 = ( (( ( temp_output_18_0 - temp_output_19_0 ) * temp_output_28_0 )).xy * appendResult56 );
			float4 color73 = IsGammaSpace() ? float4(0.4539427,0.9528302,0.7752382,0) : float4(0.1738599,0.8960326,0.5627049,0);
			float3 ase_worldNormal = i.worldNormal;
			float3 ase_normWorldNormal = normalize( ase_worldNormal );
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = Unity_SafeNormalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float dotResult64 = dot( ase_normWorldNormal , ase_worldViewDir );
			float clampResult7_g1 = clamp( ( (0.0 + (dotResult64 - -1.0) * (1.0 - 0.0) / (1.0 - -1.0)) + _FresnelBalance ) , 0.0 , 1.0 );
			float clampResult12_g1 = clamp( pow( clampResult7_g1 , exp2( _FresnelFalloff ) ) , 0.0 , 1.0 );
			float Fresnel69 = ( ( 1.0 - clampResult12_g1 ) * _FresnelAmount );
			float4 lerpResult72 = lerp( ( lerpResult101 * tex2D( _ScreenSpaceTex, ScreenSpaceUVs31 ) ) , color73 , Fresnel69);
			float clampResult94 = clamp( ( i.vertexColor.r + ( 1.0 - _AOAmount ) ) , 0.0 , 1.0 );
			float4 lerpResult90 = lerp( color91 , ( ase_lightColor * lerpResult72 ) , clampResult94);
			o.Albedo = lerpResult90.rgb;
			o.Emission = ( lerpResult90 * 0.25 ).rgb;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows 

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
				float2 customPack1 : TEXCOORD1;
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
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = IN.worldNormal;
				surfIN.vertexColor = IN.color;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
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
0;699.4286;1229;455;21.53577;493.8353;1;True;False
Node;AmplifyShaderEditor.PosVertexDataNode;11;-2753.33,-1814.646;Float;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector3Node;13;-2751.33,-1586.645;Float;False;Constant;_Vector0;Vector 0;0;0;Create;True;0;0;False;0;0,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.UnityObjToClipPosHlpNode;12;-2525.332,-1809.646;Float;False;1;0;FLOAT3;0,0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.UnityObjToClipPosHlpNode;14;-2547.332,-1572.645;Float;False;1;0;FLOAT3;0,0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ComputeScreenPosHlpNode;15;-2362.332,-1561.645;Float;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ComputeScreenPosHlpNode;10;-2336.873,-1809.233;Float;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ComponentMaskNode;16;-2109.332,-1526.645;Float;False;False;False;False;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;26;-1882.86,-1240.721;Float;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldSpaceCameraPos;25;-1969.655,-1407.888;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ComponentMaskNode;17;-2127.759,-1697.714;Float;False;False;False;False;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;18;-1836.745,-1803.981;Float;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;19;-1834.745,-1605.981;Float;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ScreenParams;61;-1325.486,-1220.433;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;27;-1611.859,-1353.721;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.WorldNormalVector;75;-1835.204,74.05728;Float;False;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;76;-1874.087,207.2429;Float;False;World;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleSubtractOpNode;20;-1410.745,-1709.981;Float;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;62;-1079.786,-1161.933;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;24;-1039.81,-1455.267;Float;False;Property;_TexScale;Tex Scale;0;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;28;-1367.86,-1388.721;Float;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;63;-827.5853,-1329.633;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;-1138.86,-1551.721;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DotProductOpNode;64;-1487.27,133.3954;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;35;-988.3883,-1560.798;Float;False;True;True;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;71;-1342.671,448.0315;Float;False;Property;_FresnelFalloff;Fresnel Falloff;5;0;Create;True;0;0;False;0;0;0;0;11;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;97;-1358.024,341.7446;Float;False;Property;_FresnelBalance;Fresnel Balance;4;0;Create;True;0;0;False;0;0;-1;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;56;-686.8479,-1479.914;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TFHCRemapNode;67;-1354.027,135.221;Float;True;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;68;-967.6486,145.9117;Float;False;F_Balance and Falloff;-1;;1;db63d5e8967e8734489214297d7545f6;0;3;1;FLOAT;0;False;3;FLOAT;0;False;10;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;55;-614.1056,-1599.499;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;79;-650.9285,148.7584;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;78;-919.6609,291.6407;Float;False;Property;_FresnelAmount;Fresnel Amount;6;0;Create;True;0;0;False;0;0.5;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;31;-463.2321,-1575.598;Float;False;ScreenSpaceUVs;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;32;142.7758,-261.3487;Float;False;31;ScreenSpaceUVs;1;0;OBJECT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;40;97.61464,-885.1744;Float;False;Property;_TopColor;Top Color;2;0;Create;True;0;0;False;0;0.8949356,0,1,0;0.7496812,0.3973834,0.8867924,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;77;-420.6609,226.6407;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;102;112.12,-1101.635;Float;False;Property;_BottomColor;Bottom Color;3;0;Create;True;0;0;False;0;0.1703008,0.8396226,0.1726939,0;0.1703008,0.8396226,0.1726939,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;103;97.97132,-648.8749;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;69;-132.4057,147.8175;Float;False;Fresnel;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;30;377.7109,-260.2437;Float;True;Property;_ScreenSpaceTex;Screen Space Tex;1;0;Create;True;0;0;False;0;None;35fe72800ea83f84cbabd81658dbb33d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;101;535.3354,-1070.651;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;96;1304.778,174.1463;Float;False;Property;_AOAmount;AO Amount;7;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;41;923.45,-459.2546;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;104;1589.746,172.6547;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;89;1409.482,-59.39642;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;74;947.5432,285.6402;Float;False;69;Fresnel;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;73;736.5602,19.84399;Float;False;Constant;_FresnelColor;Fresnel Color;6;0;Create;True;0;0;False;0;0.4539427,0.9528302,0.7752382,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LightColorNode;82;1309.644,-467.0675;Float;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.LerpOp;72;1224.854,-267.0013;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;93;1728.578,-37.75371;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;91;1552.394,-294.1261;Float;False;Constant;_AOColor;AO Color;5;0;Create;True;0;0;False;0;0.235944,0.1490196,0.5568628,0;0.235944,0.1490196,0.5568628,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;94;1892.378,-137.8537;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;83;1546.475,-425.1478;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;99;2094.163,-43.35657;Float;False;Constant;_Float0;Float 0;8;0;Create;True;0;0;False;0;0.25;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;90;1973.782,-313.4946;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;43;-1376.983,-2002.299;Float;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;47;-712.8239,-1901.21;Float;False;ObjectScaleV;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;44;-1087.708,-1894.883;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;100;2243.163,-142.3566;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ComponentMaskNode;46;-939.9438,-1897.106;Float;False;False;True;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2600.365,-366.9832;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;New Amplify Shader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;12;0;11;0
WireConnection;14;0;13;0
WireConnection;15;0;14;0
WireConnection;10;0;12;0
WireConnection;16;0;15;0
WireConnection;17;0;10;0
WireConnection;18;0;10;0
WireConnection;18;1;17;0
WireConnection;19;0;15;0
WireConnection;19;1;16;0
WireConnection;27;0;25;0
WireConnection;27;1;26;0
WireConnection;20;0;18;0
WireConnection;20;1;19;0
WireConnection;62;0;61;1
WireConnection;62;1;61;2
WireConnection;28;0;27;0
WireConnection;63;0;24;0
WireConnection;63;1;62;0
WireConnection;29;0;20;0
WireConnection;29;1;28;0
WireConnection;64;0;75;0
WireConnection;64;1;76;0
WireConnection;35;0;29;0
WireConnection;56;0;24;0
WireConnection;56;1;63;0
WireConnection;67;0;64;0
WireConnection;68;1;67;0
WireConnection;68;3;97;0
WireConnection;68;10;71;0
WireConnection;55;0;35;0
WireConnection;55;1;56;0
WireConnection;79;0;68;0
WireConnection;31;0;55;0
WireConnection;77;0;79;0
WireConnection;77;1;78;0
WireConnection;69;0;77;0
WireConnection;30;1;32;0
WireConnection;101;0;102;0
WireConnection;101;1;40;0
WireConnection;101;2;103;2
WireConnection;41;0;101;0
WireConnection;41;1;30;0
WireConnection;104;0;96;0
WireConnection;72;0;41;0
WireConnection;72;1;73;0
WireConnection;72;2;74;0
WireConnection;93;0;89;1
WireConnection;93;1;104;0
WireConnection;94;0;93;0
WireConnection;83;0;82;0
WireConnection;83;1;72;0
WireConnection;90;0;91;0
WireConnection;90;1;83;0
WireConnection;90;2;94;0
WireConnection;43;0;18;0
WireConnection;43;1;19;0
WireConnection;47;0;46;0
WireConnection;44;0;43;0
WireConnection;44;1;28;0
WireConnection;100;0;90;0
WireConnection;100;1;99;0
WireConnection;46;0;44;0
WireConnection;0;0;90;0
WireConnection;0;2;100;0
ASEEND*/
//CHKSM=08AFF8529744F0B2E0E30DB8F3AF710D446FE70B