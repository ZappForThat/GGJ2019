// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "GGJ/Standard"
{
	Properties
	{
		_TopColor("Top Color", Color) = (0.8949356,0,1,0)
		_BottomColor("Bottom Color", Color) = (0.1703008,0.8396226,0.1726939,0)
		_FresnelBalance("Fresnel Balance", Range( -1 , 1)) = 0
		_FresnelFalloff("Fresnel Falloff", Range( 0 , 11)) = 0
		_FresnelAmount("Fresnel Amount", Range( 0 , 1)) = 0.5
		_AOAmount("AO Amount", Range( 0 , 1)) = 0
		_SketchTex("SketchTex", 2D) = "white" {}
		_Texture0("Texture 0", 2D) = "white" {}
		[Toggle]_NewShading("New Shading", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityCG.cginc"
		#include "UnityShaderVariables.cginc"
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

		uniform float _NewShading;
		uniform float4 _BottomColor;
		uniform float4 _TopColor;
		uniform sampler2D _SketchTex;
		uniform sampler2D _Texture0;
		uniform float _FresnelBalance;
		uniform float _FresnelFalloff;
		uniform float _FresnelAmount;
		uniform float _AOAmount;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 color91 = IsGammaSpace() ? float4(0.235944,0.1490196,0.5568628,0) : float4(0.04542937,0.01938236,0.2704979,0);
			float4 lerpResult101 = lerp( _BottomColor , _TopColor , i.uv_texcoord.y);
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float4 unityObjectToClipPos12 = UnityObjectToClipPos( ase_vertex3Pos );
			float4 computeScreenPos10 = ComputeScreenPos( unityObjectToClipPos12 );
			float4 temp_output_18_0 = ( computeScreenPos10 / (computeScreenPos10).w );
			float4 unityObjectToClipPos14 = UnityObjectToClipPos( float3(0,0,0) );
			float4 computeScreenPos15 = ComputeScreenPos( unityObjectToClipPos14 );
			float4 temp_output_19_0 = ( computeScreenPos15 / (computeScreenPos15).w );
			float4 transform26 = mul(unity_ObjectToWorld,float4( 0,0,0,1 ));
			float2 temp_output_35_0 = (( ( temp_output_18_0 - temp_output_19_0 ) * distance( ( float4( _WorldSpaceCameraPos , 0.0 ) - transform26 ) , float4( 0,0,0,0 ) ) )).xy;
			float2 appendResult56 = (float2(1.25 , ( 1.25 / ( _ScreenParams.x / _ScreenParams.y ) )));
			float2 temp_output_233_0 = ( temp_output_35_0 * 2.0 );
			float lerpResult226 = lerp( tex2D( _Texture0, ( temp_output_233_0 + float2( 0.6,0.6 ) ) ).r , tex2D( _Texture0, temp_output_233_0 ).r , round( (0.0 + (sin( ( _Time.y * 30.0 ) ) - -1.0) * (1.0 - 0.0) / (1.0 - -1.0)) ));
			float2 temp_output_238_0 = ( ( temp_output_35_0 * appendResult56 ) + ( (-1.0 + (lerpResult226 - 0.0) * (1.0 - -1.0) / (1.0 - 0.0)) * 0.01 ) );
			float2 UVStep131 = temp_output_238_0;
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
			float clampResult174 = clamp( ( ShadowDot113 + -0.75 ) , 0.0 , 1.0 );
			float clampResult169 = clamp( ( tex2D( _SketchTex, UVStep131 ).r + clampResult174 ) , 0.0 , 1.0 );
			float2 _Vector1 = float2(0.5,0.5);
			float cos114 = cos( ( 0.25 * 6.28318548202515 ) );
			float sin114 = sin( ( 0.25 * 6.28318548202515 ) );
			float2 rotator114 = mul( temp_output_238_0 - _Vector1 , float2x2( cos114 , -sin114 , sin114 , cos114 )) + _Vector1;
			float2 UVStep2120 = rotator114;
			float clampResult178 = clamp( ( ShadowDot113 + -0.5 ) , 0.0 , 1.0 );
			float clampResult172 = clamp( ( tex2D( _SketchTex, UVStep2120 ).r + clampResult178 ) , 0.0 , 1.0 );
			float2 temp_output_185_0 = ( 1.33 * temp_output_238_0 );
			float cos184 = cos( ( 0.125 * 6.28318548202515 ) );
			float sin184 = sin( ( 0.125 * 6.28318548202515 ) );
			float2 rotator184 = mul( temp_output_185_0 - _Vector1 , float2x2( cos184 , -sin184 , sin184 , cos184 )) + _Vector1;
			float2 UVStep3191 = rotator184;
			float clampResult180 = clamp( ( ShadowDot113 + -0.25 ) , 0.0 , 1.0 );
			float clampResult196 = clamp( ( tex2D( _SketchTex, UVStep3191 ).r + clampResult180 ) , 0.0 , 1.0 );
			float cos197 = cos( ( -0.125 * 6.28318548202515 ) );
			float sin197 = sin( ( -0.125 * 6.28318548202515 ) );
			float2 rotator197 = mul( temp_output_185_0 - _Vector1 , float2x2( cos197 , -sin197 , sin197 , cos197 )) + _Vector1;
			float2 UVStep3B200 = rotator197;
			float clampResult204 = clamp( ( tex2D( _SketchTex, UVStep3B200 ).r + clampResult180 ) , 0.0 , 1.0 );
			float temp_output_171_0 = ( clampResult169 * ( clampResult172 * clampResult172 ) * ( clampResult196 * clampResult196 * clampResult204 * clampResult204 ) );
			float clampResult147 = clamp( ( temp_output_171_0 * temp_output_171_0 ) , 0.0 , 1.0 );
			float4 color264 = IsGammaSpace() ? float4(0.9056604,0.9025276,0.8586686,0) : float4(0.7986599,0.7924232,0.7080877,0);
			float4 lerpResult263 = lerp( lerpResult101 , color264 , ( clampResult147 * clampResult147 * clampResult147 * clampResult147 * ShadowDot113 ));
			float4 color73 = IsGammaSpace() ? float4(0,0,0,0) : float4(0,0,0,0);
			float3 ase_worldViewDir = Unity_SafeNormalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float dotResult64 = dot( ase_normWorldNormal , ase_worldViewDir );
			float clampResult7_g1 = clamp( ( (0.0 + (dotResult64 - -1.0) * (1.0 - 0.0) / (1.0 - -1.0)) + _FresnelBalance ) , 0.0 , 1.0 );
			float clampResult12_g1 = clamp( pow( clampResult7_g1 , exp2( _FresnelFalloff ) ) , 0.0 , 1.0 );
			float Fresnel69 = ( ( 1.0 - clampResult12_g1 ) * _FresnelAmount );
			float4 lerpResult72 = lerp( lerp(( lerpResult101 * clampResult147 ),lerpResult263,_NewShading) , color73 , Fresnel69);
			float clampResult94 = clamp( ( i.vertexColor.r + ( 1.0 - _AOAmount ) ) , 0.0 , 1.0 );
			float4 lerpResult90 = lerp( color91 , lerpResult72 , clampResult94);
			o.Albedo = lerpResult90.rgb;
			o.Emission = ( lerpResult90 * 0.15 ).rgb;
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
0;851.4286;1432;310;1654.324;2333.773;1;True;False
Node;AmplifyShaderEditor.Vector3Node;13;-3204.218,-1711.189;Float;False;Constant;_Vector0;Vector 0;0;0;Create;True;0;0;False;0;0,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.PosVertexDataNode;11;-3206.218,-1939.19;Float;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.UnityObjToClipPosHlpNode;12;-2978.22,-1934.19;Float;False;1;0;FLOAT3;0,0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.UnityObjToClipPosHlpNode;14;-3000.22,-1697.189;Float;False;1;0;FLOAT3;0,0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ComputeScreenPosHlpNode;15;-2815.22,-1686.189;Float;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ComputeScreenPosHlpNode;10;-2789.761,-1933.777;Float;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;26;-2335.748,-1365.265;Float;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldSpaceCameraPos;25;-2422.543,-1532.432;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ComponentMaskNode;16;-2562.22,-1651.189;Float;False;False;False;False;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;17;-2580.647,-1822.258;Float;False;False;False;False;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;27;-2064.747,-1478.265;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;18;-2289.633,-1928.525;Float;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;19;-2287.633,-1730.525;Float;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;20;-1863.633,-1834.525;Float;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DistanceOpNode;28;-1820.748,-1513.265;Float;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;221;-2201.122,-2670.621;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;224;-2203.491,-2593.041;Float;False;Constant;_Float11;Float 11;9;0;Create;True;0;0;False;0;30;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;-1591.748,-1676.265;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;234;-1638.413,-2001.819;Float;False;Constant;_NoiseScale;Noise Scale;9;0;Create;True;0;0;False;0;2;1.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;35;-1441.277,-1685.342;Float;False;True;True;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;223;-2021.491,-2587.041;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;222;-1832.491,-2716.041;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;233;-1436.208,-2029.262;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;231;-1577.981,-2462.541;Float;False;Constant;_Vector2;Vector 2;9;0;Create;True;0;0;False;0;0.6,0.6;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.WorldNormalVector;106;-472.4299,-3669.268;Float;False;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TexturePropertyNode;228;-1812.515,-2349.303;Float;True;Property;_Texture0;Texture 0;9;0;Create;True;0;0;False;0;None;11bfd352aa2789f4ea8ed90fb8c05a3e;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.TFHCRemapNode;239;-1632.228,-2689.221;Float;False;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;218;-1336.208,-2388.489;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;108;-519.6608,-3521.787;Float;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ScreenParams;61;-1778.374,-1344.977;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RoundOpNode;225;-1307.1,-2736.668;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;227;-1177.089,-2369.615;Float;True;Property;_TextureSample4;Texture Sample 4;9;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;220;-1205.796,-2102.089;Float;True;Property;_TextureSample3;Texture Sample 3;9;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleDivideOpNode;62;-1532.674,-1286.477;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;105;-199.5306,-3673.128;Float;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;24;-1524.595,-1504.008;Float;False;Constant;_TexScale;Tex Scale;0;0;Create;True;0;0;False;0;1.25;6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;211;57.86459,-3469.515;Float;False;Constant;_LightBalance;Light Balance;8;0;Create;True;0;0;False;0;-0.02;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;63;-1280.474,-1454.177;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;226;-775.5676,-2260.775;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;137;26.82317,-3666.042;Float;False;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;235;-559.9771,-2253.682;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-1;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;237;-637.8328,-2061.398;Float;False;Constant;_NoiseAmount;Noise Amount;9;0;Create;True;0;0;False;0;0.01;0.0103;0;0.1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;215;291.8646,-3396.515;Float;False;Constant;_LightFalloff;Light Falloff;8;0;Create;True;0;0;False;0;1.05;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;210;276.8646,-3581.515;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;56;-1139.736,-1604.458;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;236;-306.8328,-2187.398;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;55;-932.5769,-1712.724;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ClampOpNode;212;412.8646,-3569.515;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Exp2OpNode;214;488.8646,-3425.515;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TauNode;188;365.1949,-2212.055;Float;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.TauNode;115;183.9986,-1764.4;Float;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;117;150.9986,-1844.4;Float;False;Constant;_Float1;Float 1;9;0;Create;True;0;0;False;0;0.25;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;189;301.828,-2297.839;Float;False;Constant;_Float6;Float 6;9;0;Create;True;0;0;False;0;0.125;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;186;-113.8177,-2353.957;Float;False;Constant;_Float5;Float 5;8;0;Create;True;0;0;False;0;1.33;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;199;273.8645,-2132.36;Float;False;Constant;_Float7;Float 7;9;0;Create;True;0;0;False;0;-0.125;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;213;600.8646,-3547.515;Float;True;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;238;-131.8884,-2182.62;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;119;254.2492,-1975.933;Float;False;Constant;_Vector1;Vector 1;9;0;Create;True;0;0;False;0;0.5,0.5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.ClampOpNode;216;882.8646,-3535.515;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;190;483.1948,-2286.055;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;198;551.5034,-2133.806;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;116;301.9986,-1838.4;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;185;92.87315,-2328.101;Float;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;192;939.3242,-2655.401;Float;False;336.2857;316.7144;Comment;2;191;200;UV Step 3;1,1,1,1;0;0
Node;AmplifyShaderEditor.RotatorNode;184;609.5204,-2566.514;Float;True;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;121;2504.084,-926.1227;Float;True;Property;_SketchTex;SketchTex;8;0;Create;True;0;0;False;0;None;359c415136f8e364dbf2efd32a4477f7;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;113;1047.035,-3665.651;Float;False;ShadowDot;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RotatorNode;114;644.9478,-1954.816;Float;True;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RotatorNode;197;712.4392,-2330.331;Float;True;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;182;914.4888,-2038.252;Float;False;296.2857;164.7142;Comment;1;120;UV Step 2;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;122;2786.389,-880.7224;Float;False;SketchTex;-1;True;1;0;SAMPLER2D;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;191;989.3242,-2605.401;Float;False;UVStep3;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;181;-2331.641,93.67621;Float;False;Constant;_Float4;Float 4;8;0;Create;True;0;0;False;0;-0.25;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;183;950.2703,-1566.875;Float;False;296.2857;164.7142;Comment;1;31;UV Step 1;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;129;-2973.548,-304.2274;Float;False;113;ShadowDot;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;177;-2331.959,-138.9583;Float;False;Constant;_Float3;Float 3;8;0;Create;True;0;0;False;0;-0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;200;985.3545,-2465.998;Float;False;UVStep3B;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;120;964.4888,-1988.252;Float;False;UVStep2;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;175;-2337.298,-354.6792;Float;False;Constant;_Float2;Float 2;8;0;Create;True;0;0;False;0;-0.75;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;179;-2312.251,-32.60561;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;202;-1636.117,250.4394;Float;False;200;UVStep3B;1;0;OBJECT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;176;-2312.569,-265.2401;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;125;-1679.03,-85.15205;Float;False;120;UVStep2;1;0;OBJECT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;194;-1641.298,143.6112;Float;False;191;UVStep3;1;0;OBJECT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;31;1000.27,-1516.875;Float;False;UVStep1;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;123;-1656.402,-537.3752;Float;False;122;SketchTex;1;0;OBJECT;0;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.ClampOpNode;180;-2132.641,-10.3238;Float;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;173;-2325.801,-458.1501;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;201;-1386.035,364.85;Float;True;Property;_TextureSample2;Texture Sample 2;1;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;124;-1442.9,-102.3071;Float;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;178;-2132.959,-242.9583;Float;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;193;-1400.344,143.6112;Float;True;Property;_TextureSample1;Texture Sample 1;1;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;32;-1683.356,-444.2319;Float;False;31;UVStep1;1;0;OBJECT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ClampOpNode;174;-2128.713,-462.4349;Float;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;203;-944.1894,223.7256;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;30;-1425.578,-532.128;Float;True;Property;_ScreenSpaceTex;Screen Space Tex;1;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;170;-945.1322,-251.5912;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;195;-958.2195,33.04131;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;76;-1321.686,-2965.334;Float;False;World;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;168;-939.1567,-444.6071;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;204;-782.2946,226.5256;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;75;-1282.803,-3098.52;Float;False;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ClampOpNode;196;-790.1341,16.29928;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;172;-780.9121,-246.4294;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;169;-769.8971,-440.716;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;206;-617.1635,-249.7918;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;64;-934.8687,-3039.182;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;209;-533.4355,24.90656;Float;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;71;-790.2697,-2724.545;Float;False;Property;_FresnelFalloff;Fresnel Falloff;5;0;Create;True;0;0;False;0;0;0;0;11;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;171;-418.4232,-431.1041;Float;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;67;-801.6258,-3037.356;Float;True;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;97;-805.6227,-2830.832;Float;False;Property;_FresnelBalance;Fresnel Balance;4;0;Create;True;0;0;False;0;0;-1;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;240;-191.0812,-415.2201;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;68;-415.2474,-3026.665;Float;False;F_Balance and Falloff;-1;;1;db63d5e8967e8734489214297d7545f6;0;3;1;FLOAT;0;False;3;FLOAT;0;False;10;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;79;-98.52717,-3023.819;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;78;-113.2595,-2756.936;Float;False;Property;_FresnelAmount;Fresnel Amount;6;0;Create;True;0;0;False;0;0.5;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;40;36.71055,-776.9004;Float;False;Property;_TopColor;Top Color;2;0;Create;True;0;0;False;0;0.8949356,0,1,0;1,0.9295731,0.6462264,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;102;51.21591,-993.361;Float;False;Property;_BottomColor;Bottom Color;3;0;Create;True;0;0;False;0;0.1703008,0.8396226,0.1726939,0;0.7830188,0.7217219,0.6685208,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;270;335.0732,-60.02686;Float;False;113;ShadowDot;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;103;37.06723,-540.6008;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;147;230.8975,-268.0681;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;266;579.6831,-217.8762;Float;False;5;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;101;383.075,-803.3493;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;77;131.7405,-2945.936;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;264;331.3654,-493.9323;Float;False;Constant;_Color0;Color 0;10;0;Create;True;0;0;False;0;0.9056604,0.9025276,0.8586686,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;96;1304.778,174.1463;Float;False;Property;_AOAmount;AO Amount;7;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;69;376.0156,-2979.622;Float;False;Fresnel;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;104;1589.746,172.6547;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;263;832.8939,-355.358;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;41;923.45,-459.2546;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;89;1409.482,-59.39642;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;73;736.5602,19.84399;Float;False;Constant;_FresnelColor;Fresnel Color;6;0;Create;True;0;0;False;0;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;93;1728.578,-37.75371;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;74;1107.478,239.9444;Float;False;69;Fresnel;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;265;1145.765,-612.3322;Float;False;Property;_NewShading;New Shading;10;0;Create;True;0;0;False;0;0;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;72;1228.996,-314.4714;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;94;1892.378,-137.8537;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;91;1623.793,-585.4366;Float;False;Constant;_AOColor;AO Color;5;0;Create;True;0;0;False;0;0.235944,0.1490196,0.5568628,0;0.235944,0.1490196,0.5568628,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;90;1973.782,-313.4946;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;99;2065.163,-42.35657;Float;False;Constant;_Float0;Float 0;8;0;Create;True;0;0;False;0;0.15;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;262;2487.213,-525.6749;Float;False;FetchLightmapValue;0;;2;43de3d4ae59f645418fdd020d1b8e78e;0;0;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;136;2378.219,226.1776;Float;False;113;ShadowDot;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;217;-129.584,-1771.057;Float;False;ScreenUVs;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;100;2306.163,-326.3566;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;43;-1832.155,-2072.165;Float;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;208;-802.84,145.5985;Float;False;Constant;_Float9;Float 9;8;0;Create;True;0;0;False;0;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2809.966,-397.3832;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;GGJ/Standard;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;12;0;11;0
WireConnection;14;0;13;0
WireConnection;15;0;14;0
WireConnection;10;0;12;0
WireConnection;16;0;15;0
WireConnection;17;0;10;0
WireConnection;27;0;25;0
WireConnection;27;1;26;0
WireConnection;18;0;10;0
WireConnection;18;1;17;0
WireConnection;19;0;15;0
WireConnection;19;1;16;0
WireConnection;20;0;18;0
WireConnection;20;1;19;0
WireConnection;28;0;27;0
WireConnection;29;0;20;0
WireConnection;29;1;28;0
WireConnection;35;0;29;0
WireConnection;223;0;221;0
WireConnection;223;1;224;0
WireConnection;222;0;223;0
WireConnection;233;0;35;0
WireConnection;233;1;234;0
WireConnection;239;0;222;0
WireConnection;218;0;233;0
WireConnection;218;1;231;0
WireConnection;225;0;239;0
WireConnection;227;0;228;0
WireConnection;227;1;218;0
WireConnection;220;0;228;0
WireConnection;220;1;233;0
WireConnection;62;0;61;1
WireConnection;62;1;61;2
WireConnection;105;0;106;0
WireConnection;105;1;108;0
WireConnection;63;0;24;0
WireConnection;63;1;62;0
WireConnection;226;0;227;1
WireConnection;226;1;220;1
WireConnection;226;2;225;0
WireConnection;137;0;105;0
WireConnection;235;0;226;0
WireConnection;210;0;137;0
WireConnection;210;1;211;0
WireConnection;56;0;24;0
WireConnection;56;1;63;0
WireConnection;236;0;235;0
WireConnection;236;1;237;0
WireConnection;55;0;35;0
WireConnection;55;1;56;0
WireConnection;212;0;210;0
WireConnection;214;0;215;0
WireConnection;213;0;212;0
WireConnection;213;1;214;0
WireConnection;238;0;55;0
WireConnection;238;1;236;0
WireConnection;216;0;213;0
WireConnection;190;0;189;0
WireConnection;190;1;188;0
WireConnection;198;0;199;0
WireConnection;198;1;188;0
WireConnection;116;0;117;0
WireConnection;116;1;115;0
WireConnection;185;0;186;0
WireConnection;185;1;238;0
WireConnection;184;0;185;0
WireConnection;184;1;119;0
WireConnection;184;2;190;0
WireConnection;113;0;216;0
WireConnection;114;0;238;0
WireConnection;114;1;119;0
WireConnection;114;2;116;0
WireConnection;197;0;185;0
WireConnection;197;1;119;0
WireConnection;197;2;198;0
WireConnection;122;0;121;0
WireConnection;191;0;184;0
WireConnection;200;0;197;0
WireConnection;120;0;114;0
WireConnection;179;0;129;0
WireConnection;179;1;181;0
WireConnection;176;0;129;0
WireConnection;176;1;177;0
WireConnection;31;0;238;0
WireConnection;180;0;179;0
WireConnection;173;0;129;0
WireConnection;173;1;175;0
WireConnection;201;0;123;0
WireConnection;201;1;202;0
WireConnection;124;0;123;0
WireConnection;124;1;125;0
WireConnection;178;0;176;0
WireConnection;193;0;123;0
WireConnection;193;1;194;0
WireConnection;174;0;173;0
WireConnection;203;0;201;1
WireConnection;203;1;180;0
WireConnection;30;0;123;0
WireConnection;30;1;32;0
WireConnection;170;0;124;1
WireConnection;170;1;178;0
WireConnection;195;0;193;1
WireConnection;195;1;180;0
WireConnection;168;0;30;1
WireConnection;168;1;174;0
WireConnection;204;0;203;0
WireConnection;196;0;195;0
WireConnection;172;0;170;0
WireConnection;169;0;168;0
WireConnection;206;0;172;0
WireConnection;206;1;172;0
WireConnection;64;0;75;0
WireConnection;64;1;76;0
WireConnection;209;0;196;0
WireConnection;209;1;196;0
WireConnection;209;2;204;0
WireConnection;209;3;204;0
WireConnection;171;0;169;0
WireConnection;171;1;206;0
WireConnection;171;2;209;0
WireConnection;67;0;64;0
WireConnection;240;0;171;0
WireConnection;240;1;171;0
WireConnection;68;1;67;0
WireConnection;68;3;97;0
WireConnection;68;10;71;0
WireConnection;79;0;68;0
WireConnection;147;0;240;0
WireConnection;266;0;147;0
WireConnection;266;1;147;0
WireConnection;266;2;147;0
WireConnection;266;3;147;0
WireConnection;266;4;270;0
WireConnection;101;0;102;0
WireConnection;101;1;40;0
WireConnection;101;2;103;2
WireConnection;77;0;79;0
WireConnection;77;1;78;0
WireConnection;69;0;77;0
WireConnection;104;0;96;0
WireConnection;263;0;101;0
WireConnection;263;1;264;0
WireConnection;263;2;266;0
WireConnection;41;0;101;0
WireConnection;41;1;147;0
WireConnection;93;0;89;1
WireConnection;93;1;104;0
WireConnection;265;0;41;0
WireConnection;265;1;263;0
WireConnection;72;0;265;0
WireConnection;72;1;73;0
WireConnection;72;2;74;0
WireConnection;94;0;93;0
WireConnection;90;0;91;0
WireConnection;90;1;72;0
WireConnection;90;2;94;0
WireConnection;217;0;238;0
WireConnection;100;0;90;0
WireConnection;100;1;99;0
WireConnection;43;0;18;0
WireConnection;43;1;19;0
WireConnection;0;0;90;0
WireConnection;0;2;100;0
ASEEND*/
//CHKSM=41F029071AE2DA184C7DE12AE7AFA295EBE24E60