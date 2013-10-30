using UnityEngine;
using System.Collections;
using System.Runtime.InteropServices; // Don't forget this!

public class VideoMesh : MonoBehaviour {
	
	void Start () {
		// not necessary now, but we'll use it later
	}


	[DllImport("__Internal")]
	private static extern void _setVideo(string filename);

	public void SetVideo(string filename) {
		if (Application.platform == RuntimePlatform.IPhonePlayer) {
			_setVideo(filename);
		}
	}


	[DllImport("__Internal")]
	private static extern void _play();

	public void Play() {
		if (Application.platform == RuntimePlatform.IPhonePlayer) {
			_play();
		}
	}


	[DllImport("__Internal")]
	private static extern void _pause();

	public void Pause() {
		if (Application.platform == RuntimePlatform.IPhonePlayer) {
			_pause();
		}
	}

}
