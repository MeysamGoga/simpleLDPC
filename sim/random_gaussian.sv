//==============================================================
// File : sim/random_gaussian.sv
//==============================================================

`timescale 1ns/1ps
`default_nettype none

module random_gaussian;

    real u1;
    real u2;
    real g;

    task automatic gaussian
    (
        output real value
    );

        begin

            u1 = ($urandom + 1.0) / 4294967296.0;
            u2 = ($urandom + 1.0) / 4294967296.0;

            g = $sqrt(-2.0*$ln(u1))
                *
                $cos(2.0*3.1415926535*u2);

            value = g;

        end

    endtask

endmodule

`default_nettype wire
