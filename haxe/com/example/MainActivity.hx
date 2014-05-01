package com.example;

import android.support.v4.app.FragmentActivity;
import android.os.Bundle;
import com.boltmade.android.R;
import android.view.View;

//import com.boltmade.InterfaceHandlers.toHandler;

class MainActivity extends FragmentActivity {
	@:overload function onCreate(savedInstanceState:Bundle) {
		super.onCreate(savedInstanceState);
		setContentView(R.get("layout.main"));
	}

	public function onGo(view:View) {
		// do stuff
	}
}
