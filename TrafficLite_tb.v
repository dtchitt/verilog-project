module TrafficLite(EWCar, NSCar, EWLite, NSLite, clock);
  input EWCar, NSCar, clock;
  output EWLite, NSLite;
  reg state;
  initial state = 0;  //set initial state 
  //following two assignments set the output, which is based only on the state variable
  assign NSLite = ~ state; //NSLite on if state = 0;
  assign EWLite = state; //EWLite on if state =1 
  always @(posedge clock) // all state updates on a positive clock edge
    case (state)
      0: state = EWCar; //change state only if EWCar
      1: state = NSCar; //change state only if NSCar
    endcase
endmodule

module TrafficLite_tb;
  //Inputs
  reg EWCar;
  reg NSCar;
  reg clock;
  //Outputs
  wire EWLite;
  wire NSLite;

  TrafficLite uut (
    .EWCar(EWCar),
    .NSCar(NSCar),
    .EWLite(EWLite),
    .NSLite(NSLite),
    .clock(clock)
  );

  initial begin
    $dumpfile("TrafficLite_tb.vcd");
	  $dumpvars(0, TrafficLite_tb);

    EWCar = 0;
    NSCar = 0;
    clock = 0;

    #30
    clock = 1; EWCar = 1; NSCar = 0;
    #30
    clock = 0; EWCar = 1; NSCar = 0;
    #30
    clock = 1; EWCar = 0; NSCar = 1;
    #30
    clock = 0; EWCar = 0; NSCar = 1;


    $finish;
  end

endmodule