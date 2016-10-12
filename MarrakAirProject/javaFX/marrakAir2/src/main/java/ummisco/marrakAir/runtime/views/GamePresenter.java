package ummisco.marrakAir.runtime.views;

import com.gluonhq.charm.glisten.application.MobileApplication;
import com.gluonhq.charm.glisten.control.AppBar;
import com.gluonhq.charm.glisten.mvc.View;
import com.gluonhq.charm.glisten.visual.MaterialDesignIcon;
import ummisco.marrakAir.runtime.GluonApplication;
import javafx.beans.value.ChangeListener;
import javafx.beans.value.ObservableValue;
import javafx.event.ActionEvent;
import javafx.event.EventHandler;
import javafx.fxml.FXML;
import javafx.scene.control.Label;

public class GamePresenter {

    @FXML
    private View game;

    private void change(ObservableValue obs, Object oldValue, Object newValue)
    {
    	if((Boolean)newValue) {
            AppBar appBar = MobileApplication.getInstance().getAppBar();
            EventHandler<ActionEvent> evt = new EventHandler<ActionEvent>() {

				@Override
				public void handle(ActionEvent event) {
					MobileApplication.getInstance().showLayer(GluonApplication.MENU_LAYER);
					
				}
			};
			
			appBar.setNavIcon(MaterialDesignIcon.MENU.button(evt));
//            appBar.setNavIcon(MaterialDesignIcon.MENU.button(e -> 
//                       MobileApplication.getInstance().showLayer(GluonApplication.MENU_LAYER)));
            appBar.setTitleText("Primary");
            
            EventHandler<ActionEvent> evt2 = new EventHandler<ActionEvent>() {

				@Override
				public void handle(ActionEvent event) {
					 System.out.println("Search");
				}
			};
			
            
            appBar.getActionItems().add(MaterialDesignIcon.SEARCH.button(evt2));
        }
    }
  
    public void initialize() {
    	
    	ChangeListener<? super Boolean> et = new ChangeListener() {

			@Override
			public void changed(ObservableValue observable, Object oldValue, Object newValue) {
				change(observable,oldValue,newValue);
				
			}
		};
    	
    	game.showingProperty().addListener(et);
	
    //	game.showingProperty().addListener();
    }
    
    @FXML
    void buttonClick() {
     //   label.setText("Hello JavaFX Universe!");
    }
    
}
