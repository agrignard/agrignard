package ummisco.marrakAir.gui.widgets;

import com.gluonhq.charm.glisten.layout.layer.FloatingActionButton;
import com.gluonhq.charm.glisten.visual.MaterialDesignIcon;

import javafx.beans.value.ChangeListener;
import javafx.beans.value.ObservableValue;
import javafx.event.ActionEvent;
import javafx.event.Event;
import javafx.event.EventHandler;
import javafx.geometry.Insets;
import javafx.geometry.Orientation;
import javafx.geometry.Pos;
import javafx.scene.Node;
import javafx.scene.control.Label;
import javafx.scene.control.Slider;
import javafx.scene.input.MouseEvent;
import javafx.scene.layout.HBox;
import javafx.scene.layout.Pane;
import javafx.scene.layout.VBox;

public class SliderBox extends VBox {
	
	private static final String DEFAULT_LABEL = "UNDEFINED";
	private static final float DEFAULT_MIN_VALUE = 0;
	private static final float DEFAULT_MAX_VALUE = 100;
	private Slider slider;
	private Label label;
	private double value;
	private String agentName;
	private String agentAttribute;
	
	private boolean drawLabel = true;
	private boolean drawButton = true;
	
	
	public SliderBox()
	{
		this(DEFAULT_LABEL,DEFAULT_MIN_VALUE,DEFAULT_MAX_VALUE);
	}
	
	public SliderBox(String textLabel,float min, float max)
	{
		super();
		this.slider=new Slider(min,max,(max-min)/2);
		this.slider.setOrientation(Orientation.VERTICAL);
		slider.setShowTickLabels(true);
		slider.setShowTickMarks(true);
		slider.setMajorTickUnit(50);
		slider.setMinorTickCount(5);
		slider.setBlockIncrement(10);
		ChangeListener<Number> etmp = new ChangeListener<Number>() {
			@Override
			public void changed(ObservableValue<? extends Number> observable, Number oldValue, Number newValue) {
				System.out.println("old "+ oldValue+" "+newValue);
			}
		};
		slider.valueProperty().addListener(etmp);
				/*new ChangeListener<Number>() {
			@Override
			public void changed(ObservableValue<? extends Number> observable, Number oldValue, Number newValue) {
				System.out.println("old "+ oldValue+" "+newValue);
				// TODO Auto-generated method stub
			}
		});*/
		this.value = slider.getValue();
		
		
		EventHandler<? super MouseEvent> ehand = new EventHandler<Event>() {

			@Override
			public void handle(Event event) {
				if(value != slider.getValue()) {
					value = slider.getValue();
					fireEvent(new ValueChangedEvent(agentName,agentAttribute,value));
				}
				
			}
		};
		slider.setOnMouseReleased(ehand);
		/*slider.setOnMouseReleased((Event e) -> { 
			if(this.value != slider.getValue()) {
				this.value = slider.getValue();
				this.fireEvent(new ValueChangedEvent(this.agentName,this.agentAttribute,this.value));
			}
		});*/
		
		EventHandler<? super ValueChangedEvent> evt = new EventHandler<Event>() {

			@Override
			public void handle(Event event) {
				System.out.println(event);
				
			}
		};
		this.setOnValueChanged(evt);
		
		this.setAlignment(Pos.CENTER);
		this.label=new Label(textLabel);
		initializeDisplay();
	}
	
	private void initializeDisplay()
	{
		this.setAlignment(Pos.CENTER);
		this.getChildren().clear();
		this.getChildren().add(drawSlider());
		if(this.drawLabel)
			this.getChildren().add(label);

	}
	
	private Node drawSlider()
	{
		if(drawButton == false)
			return this.slider;
		Pane res = null ; 
		EventHandler<ActionEvent> evt1 = new EventHandler<ActionEvent>() {

			@Override
			public void handle(ActionEvent event) {
				slider.increment();
			}
		};
		FloatingActionButton badd = new FloatingActionButton(MaterialDesignIcon.ADD.text, evt1);
		EventHandler<ActionEvent> evt2 = new EventHandler<ActionEvent>() {

			@Override
			public void handle(ActionEvent event) {
				slider.decrement();
			}
		};

		FloatingActionButton bremove = new FloatingActionButton(MaterialDesignIcon.REMOVE.text, evt2);
        this.setAlignment(Pos.CENTER);
        badd.setAlignment(Pos.CENTER);
        badd.setPrefHeight(DEFAULT_MAX_VALUE);
        bremove.setAlignment(Pos.CENTER);
        badd.setPadding(new Insets(10,0,20,0));
        bremove.setPadding(new Insets(20,0,20,0));
		//this.setPadding(new Insets(100));
		
       if(this.slider.getOrientation()==Orientation.VERTICAL)
			{
    	   	VBox res1 =  new VBox();
            (res1).getChildren().add(badd);
            (res1).getChildren().add(this.slider);
            (res1).getChildren().add(bremove);
            res1.setSpacing(0);
            res = res1;
			}
		else
			{
				res =  new HBox();
		          (res).getChildren().add(bremove);
		            (res).getChildren().add(this.slider);
		            (res).getChildren().add(badd);
		  
			}

     	return res;
	}
	
	
	public void setVertical(Boolean b)
	{
		this.slider.setOrientation(b?Orientation.VERTICAL:Orientation.HORIZONTAL);
		initializeDisplay();

	}
	public void setVertical(String b)
	{
		setVertical(b.equalsIgnoreCase("true"));
	}
	
	
//    private ObjectProperty<EventHandler<ValueChangedEvent>> propertyOnAction = new SimpleObjectProperty<EventHandler<ValueChangedEvent>>();
    
    private  EventHandler<? super ValueChangedEvent> changedEventHandler = null;
    
  /*  public final ObjectProperty<EventHandler<ValueChangedEvent>> onMaouProperty() {
        return propertyOnAction;
    }
*/
    public final void setOnValueChanged(EventHandler<? super ValueChangedEvent> value) 
    {
    	this.addEventHandler(ValueChangedEvent.VALUE_CHANGED, value);
        changedEventHandler = value;
    }
    
   
    public final  EventHandler<? super ValueChangedEvent> getOnValueChanged() {
        return changedEventHandler;

    }
	
	public String getVertical()
	{
		return Boolean.valueOf(this.slider.getOrientation()==Orientation.VERTICAL).toString();
	}
	
	public void setLabel(String lbl)
	{
		this.label.setText(lbl);
	}
	
	public String getLabel()
	{
		return this.label.getText();
	}

	public void setAgentName(String lbl)
	{
		this.agentName= lbl;
	}
	
	public String getAgentName()
	{
		return this.agentName;
	}

	public void setAgentAttribute(String lbl)
	{
		this.agentAttribute= lbl;
	}
	
	public String getAgentAttribute()
	{
		return this.agentAttribute;
	}

	
}
