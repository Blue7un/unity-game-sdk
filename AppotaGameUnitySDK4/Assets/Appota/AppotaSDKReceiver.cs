﻿using UnityEngine;
using System;
using System.Collections;
using System.Threading;
using SimpleJSON;

public class AppotaSDKReceiver : MonoBehaviour {
	private static GameObject playGameObject;
	private static bool initialized;
	
	private static AppotaSDKReceiver _instance;
	
	// Singleton for SDK handler
	public static AppotaSDKReceiver Instance
	{
		get
		{
			if(_instance == null) _instance = new AppotaSDKReceiver();
			return _instance;
		}
	}
	
	public static void InitializeGameObjects()
	{
		if(!initialized)
		{
			playGameObject = new GameObject("AppotaSDKReceiver");
			playGameObject.AddComponent(typeof(AppotaSDKReceiver));
			//keep this game object around for all scenes
			DontDestroyOnLoad(playGameObject);		
			initialized = true;
		}	
	}
	
	public void OnLoginSuccess(string appotaSession)
	{
		// Get User info from AppotaSession
		AppotaSession appotaSessionObj = new AppotaSession(appotaSession);
		AppotaSession.Instance.UpdateInstance(appotaSessionObj);
		
		Debug.Log ("AppotaSDK: Did login");
	}
	
	public void OnLoginError(string error)
	{
		Debug.Log ("AppotaSDK: Login Error: " + error);
	}
	
	public void OnLogoutSuccess()
	{ 
		Debug.Log ("AppotaSDK: Did logout");
	}
	
	public void OnPaymentSuccess(string transactionResult)
	{
		// Parse Transaction result into class AppotaPaymentResult.cs
		AppotaPaymentResult paymentResult = new AppotaPaymentResult(transactionResult);
		Debug.Log ("AppotaSDK Currency: " + paymentResult.Currency);

		// Parse amount, packageID, in AppPaymentResult
		Debug.Log ("AppotaSDK: Did payment");
		Debug.Log("Appota: " + transactionResult);
	}
	
	public void OnPaymentError(string error)
    {
        Debug.Log ("AppotaSDK: Payment Error: " + error);
    }
    
    public void OnCloseLoginView()
    {
        Debug.Log ("AppotaSDK: Close Login View");
    }

	public void OnOpenPaymentView()
	{
		#if UNITY_ANDROID
		// Must call this function to start Callback Thread
		AppotaThreadHandler.Instance.Start();
		#endif
		
		Debug.Log ("AppotaSDK: Open Payment View");
	}
    
    public void OnClosePaymentView()
    {
        #if UNITY_ANDROID
		// Must call this function to stop Callback Thread
		AppotaThreadHandler.Instance.Stop();
        #endif
        
        Debug.Log ("AppotaSDK: Close Payment View");
    }
    
    public void GetPaymentState(string packageID)
    {
        Debug.Log ("AppotaSDK: PackageID: " + packageID);
		string paymentState = packageID;
        
		// Game info can be set and change during your game play via GlobalGameVariables
		string gameServerID = GlobalGameVariables.Instance.gameServerID;
		string gameUserID = GlobalGameVariables.Instance.gameUserID;
		string gameInfo = GlobalGameVariables.Instance.gameInfo;
		
		paymentState += "|" + gameInfo + "|" + gameServerID + "|" + gameUserID;

#if UNITY_ANDROID || UNITY_IPHONE
        AppotaSDKHandler.Instance.SendStateToWrapper(paymentState);
#endif
	}
	
}
