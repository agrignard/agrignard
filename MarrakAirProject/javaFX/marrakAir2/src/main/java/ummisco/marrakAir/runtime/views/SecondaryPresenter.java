package ummisco.marrakAir.runtime.views;

import com.gluonhq.charm.glisten.animation.BounceInRightTransition;
import com.gluonhq.charm.glisten.application.MobileApplication;
import com.gluonhq.charm.glisten.control.AppBar;
import com.gluonhq.charm.glisten.layout.layer.FloatingActionButton;
import com.gluonhq.charm.glisten.mvc.View;
import com.gluonhq.charm.glisten.visual.MaterialDesignIcon;
import ummisco.marrakAir.runtime.GluonApplication;
import javafx.fxml.FXML;

public class SecondaryPresenter {

    @FXML
    private View secondary;

    public void initialize() {
      /*  secondary.setShowTransitionFactory(BounceInRightTransition::new);
        FloatingActionButton btt = new FloatingActionButton(MaterialDesignIcon.ADD.text, e -> System.out.println("Info:"+MaterialDesignIcon.INFO.text+":"));
        secondary.getLayers().add(btt);
        FloatingActionButton bttm = new FloatingActionButton(MaterialDesignIcon.REMOVE.text, e -> System.out.println("Info:"+MaterialDesignIcon.INFO.text+":"));
        secondary.getLayers().add(bttm);
        secondary.showingProperty().addListener((obs, oldValue, newValue) -> {
            if (newValue) {
                AppBar appBar = MobileApplication.getInstance().getAppBar();
                appBar.setNavIcon(MaterialDesignIcon.MENU.button(e -> 
                        MobileApplication.getInstance().showLayer(GluonApplication.MENU_LAYER)));
               appBar.setTitleText("Secondary");
               
               
               
               
                appBar.getActionItems().add(MaterialDesignIcon.FAVORITE.button(e -> 
                        System.out.println("Favorite")));
            }
        });*/ 
    }
}
