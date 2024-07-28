**Overview** <br />
A Synchronous FIFO buffer is a critical component in digital circuits used for temporary data storage, ensuring data is written and read in the same order. This project implements a Synchronous FIFO using Icarus Verilog and provides multiple testbenches to validate the design.

**Features**  <br />
Implementation of Synchronous FIFO.
Multiple testbenches to validate functionality and corner cases.
Outputs can be viewed using GTKWave.

**Implementation:**  <br />
Two implementations of the FIFO Buffer have been tested:  <br />
_Implementation1:_ Using an additional bit to check wrap around condition of the circular buffer.  <br />
_Implementation2:_ Using a count variable to check wrap around condition. Manipulating this variable effectively dyring and read and write operations is key.

**Requirements:**  <br />
  Icarus Verilog  <br />
  GTKWave  <br />

**Contributing**  <br />
Contributions are welcome! Please fork the repository and create a pull request with your changes. For major changes, please open an issue first to discuss what you would like to change.
