using UnityEngine;
using System;
using System.Collections;
using System.Runtime.InteropServices; // Don't forget this!

[AttributeUsage (AttributeTargets.Method)]
public sealed class MonoPInvokeCallbackAttribute : Attribute {
	public MonoPInvokeCallbackAttribute (Type t) {}
}


[RequireComponent(typeof(Renderer))]
public class VideoMesh : MonoBehaviour {

#if UNITY_EDITOR
	private const string VideoMeshDll = "VideoMesh";
#elif UNITY_IPHONE
	private const string VideoMeshDll = "__Internal";
#endif

	private bool platformSupported;
	
	public string filename;
	public bool playAutomatically;
	
	public delegate void nativeCallback(string message);
	private Texture2D videoTex;

	void Start () {
		platformSupported = (Application.platform == RuntimePlatform.IPhonePlayer ||
		                     Application.platform == RuntimePlatform.OSXEditor);

		SetLogCallback(PrintLog);

		SetTexture(renderer.material); 
		SetVideo("file://" + Application.streamingAssetsPath + "/" + filename);

		if (playAutomatically) {
			Play();
		}
	}

	void Update() {
		UpdateVideoFrame();
	}
	
	[MonoPInvokeCallback(typeof(nativeCallback))]
	public void PrintLog(string message) {
		Debug.Log(message);
	}

	[DllImport(VideoMeshDll)]
	private static extern void _setLogCallback(nativeCallback callback);

	public void SetLogCallback(nativeCallback callback) {
		if (platformSupported) {
			_setLogCallback(callback);
		}
	}


	[DllImport(VideoMeshDll)]
	private static extern void _setTexture(int tex); 

	public void SetTexture(Material material) {
		videoTex = new Texture2D(1024, 1024, TextureFormat.BGRA32, false);
		material.mainTexture = videoTex; 

		if (platformSupported) {
			int nativeID = videoTex.GetNativeTextureID();
			_setTexture(nativeID);
		}
	}
	
	[DllImport(VideoMeshDll)]
	private static extern void _setVideo(string filePath);

	public void SetVideo(string filePath) {
		if (platformSupported) {
			_setVideo(filePath);
		}
	}


	[DllImport(VideoMeshDll)]
	private static extern void _play();

	public void Play() {
		if (platformSupported) {
			_play();
		}
	}
	
	[DllImport(VideoMeshDll)]
	private static extern void _pause();

	public void Pause() {
		if (platformSupported) {
			_pause();
		}
	}

	[DllImport(VideoMeshDll)]
	private static extern void _update();

	public void UpdateVideoFrame() {
		if (platformSupported) {
			_update();
		}
	}

}
