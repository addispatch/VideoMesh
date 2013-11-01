using UnityEngine;
using System.Collections;
using System.Runtime.InteropServices; // Don't forget this!


[RequireComponent(typeof(Renderer))]
public class VideoMesh : MonoBehaviour {

	private bool platformSupported;

	public bool playAutomatically;
	
	void Start () {
		platformSupported = (Application.platform == RuntimePlatform.IPhonePlayer);

		SetTexture(renderer.sharedMaterial.mainTexture);
		SetVideo("file://" + Application.streamingAssetsPath + "/sample_mpeg4.mp4");

		if (playAutomatically) {
			Play();
		}
	}

	void Update() {
		UpdateVideoFrame();
	}

	
	[DllImport("__Internal")]
	private static extern void _setTexture(int tex); 

	public void SetTexture(Texture texture) {
		if (texture == null) { 
			texture = new Texture2D(1024, 1024, TextureFormat.RGBA32, false);
		}

		if (platformSupported) {
			int nativeID = texture.GetNativeTextureID();
			_setTexture(nativeID);
		}
	}
	
	[DllImport("__Internal")]
	private static extern void _setVideo(string filePath);

	public void SetVideo(string filePath) {
		if (platformSupported) {
			_setVideo(filePath);
		}
	}


	[DllImport("__Internal")]
	private static extern void _play();

	public void Play() {
		if (platformSupported) {
			_play();
		}
	}
	
	[DllImport("__Internal")]
	private static extern void _pause();

	public void Pause() {
		if (platformSupported) {
			_pause();
		}
	}

	[DllImport("__Internal")]
	private static extern void _update();

	public void UpdateVideoFrame() {
		if (platformSupported) {
			_update();
		}
	}

}
