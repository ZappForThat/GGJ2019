// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Transparent Depth"
{
	Properties
	{
		_Amount("Amount", Range( 0 , 1)) = 1
		_FadeDistance("Fade Distance", Float) = 1
		_Falloff("Falloff", Range( 0 , 11)) = 1
		_Color("Color", Color) = (1,1,1,0)
		_Emission("Emission", Range( 1 , 4)) = 1
		_USpeed("U Speed", Float) = 0
		_VSpeed("V Speed", Float) = 0
		_Dots("Dots", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		CGPROGRAM
		#include "UnityCG.cginc"
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard alpha:fade keepalpha noshadow vertex:vertexDataFunc 
		struct Input
		{
			float4 vertexColor : COLOR;
			float4 screenPosition1;
			float2 uv_texcoord;
		};

		uniform float4 _Color;
		uniform float _Emission;
		uniform float _Falloff;
		uniform float _Amount;
		uniform sampler2D _CameraDepthTexture;
		uniform float _FadeDistance;
		uniform sampler2D _Dots;
		uniform float4 _Dots_ST;
		uniform float _USpeed;
		uniform float _VSpeed;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertex3Pos = v.vertex.xyz;
			float3 vertexPos1 = ase_vertex3Pos;
			float4 ase_screenPos1 = ComputeScreenPos( UnityObjectToClipPos( vertexPos1 ) );
			o.screenPosition1 = ase_screenPos1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			o.Emission = ( _Color * _Emission ).rgb;
			float clampResult7_g1 = clamp( ( i.vertexColor.r + 0.0 ) , 0.0 , 1.0 );
			float clampResult12_g1 = clamp( pow( clampResult7_g1 , exp2( _Falloff ) ) , 0.0 , 1.0 );
			float4 ase_screenPos1 = i.screenPosition1;
			float4 ase_screenPosNorm1 = ase_screenPos1 / ase_screenPos1.w;
			ase_screenPosNorm1.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm1.z : ase_screenPosNorm1.z * 0.5 + 0.5;
			float screenDepth1 = LinearEyeDepth(UNITY_SAMPLE_DEPTH(tex2Dproj(_CameraDepthTexture,UNITY_PROJ_COORD( ase_screenPos1 ))));
			float distanceDepth1 = abs( ( screenDepth1 - LinearEyeDepth( ase_screenPosNorm1.z ) ) / ( _FadeDistance ) );
			float clampResult6 = clamp( distanceDepth1 , 0.0 , 1.0 );
			float2 uv_Dots = i.uv_texcoord * _Dots_ST.xy + _Dots_ST.zw;
			float2 appendResult25 = (float2(( _USpeed * _Time.y ) , ( _Time.y * _VSpeed )));
			o.Alpha = ( clampResult12_g1 * _Amount * clampResult6 * tex2D( _Dots, ( uv_Dots + appendResult25 ) ).r );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16200
0;591.4286;1289;563;2808.892;526.0906;1.73333;True;False
Node;AmplifyShaderEditor.RangedFloatNode;21;-2060.522,-33.84298;Float;False;Property;_USpeed;U Speed;6;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;22;-2035.165,203.2006;Float;False;Property;_VSpeed;V Speed;7;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;20;-2124.469,65.38456;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;-1860.965,5.848072;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;28;-1865.96,-413.4241;Float;True;Property;_Dots;Dots;8;0;Create;True;0;0;False;0;None;None;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;-1803.633,157.9969;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;5;-1152.268,527.9332;Float;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;4;-1158.268,732.9336;Float;False;Property;_FadeDistance;Fade Distance;1;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;25;-1699.995,22.38595;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;18;-1848.836,-155.1212;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;27;-1427.902,-68.34129;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DepthFade;1;-902.3787,606.891;Float;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-1173.263,394.7366;Float;False;Property;_Falloff;Falloff;2;0;Create;True;0;0;False;0;1;1;0;11;0;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;8;-1125.983,206.0601;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;12;-780.2632,375.7366;Float;False;Property;_Amount;Amount;0;0;Create;True;0;0;False;0;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;9;-825.8007,207.9972;Float;False;F_Balance and Falloff;-1;;1;db63d5e8967e8734489214297d7545f6;0;3;1;FLOAT;0;False;3;FLOAT;0;False;10;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;16;-698.2165,-269.9734;Float;False;Property;_Emission;Emission;4;0;Create;True;0;0;False;0;1;1;1;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;6;-605.2672,574.9332;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;13;-603.6396,-467.1775;Float;False;Property;_Color;Color;3;0;Create;True;0;0;False;0;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;17;-1148.752,-123.4054;Float;True;Property;_Mask;Mask;5;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;-341.7809,-317.7431;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-418.2631,243.7366;Float;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;Transparent Depth;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;23;0;21;0
WireConnection;23;1;20;0
WireConnection;26;0;20;0
WireConnection;26;1;22;0
WireConnection;25;0;23;0
WireConnection;25;1;26;0
WireConnection;18;2;28;0
WireConnection;27;0;18;0
WireConnection;27;1;25;0
WireConnection;1;1;5;0
WireConnection;1;0;4;0
WireConnection;9;1;8;1
WireConnection;9;10;10;0
WireConnection;6;0;1;0
WireConnection;17;0;28;0
WireConnection;17;1;27;0
WireConnection;15;0;13;0
WireConnection;15;1;16;0
WireConnection;11;0;9;0
WireConnection;11;1;12;0
WireConnection;11;2;6;0
WireConnection;11;3;17;1
WireConnection;0;2;15;0
WireConnection;0;9;11;0
ASEEND*/
//CHKSM=24BD09FD8908DBDBCED34F8EE76548A799C2D350