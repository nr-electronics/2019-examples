module clock_divider
#
(
    parameter [7:0] n = 3
)
(
    input  clk,
    input  rst,
    output div_clk
);

    reg [7:0] cnt;

    always @ (posedge clk or posedge rst)
        if (rst)
            cnt <= 0;
        else if (cnt == 0)
            cnt <= n - 1;
        else
            cnt <= cnt - 1;

    reg div_clk_unadjusted;

    always @ (posedge clk or posedge rst)
        if (rst)
            div_clk_unadjusted <= 0;
        else if (cnt == n - 1 || cnt == (n - 1) / 2)
            div_clk_unadjusted <= ~ div_clk_unadjusted;

    generate

        if (n % 2 == 0)
        begin
            assign div_clk = div_clk_unadjusted;
        end
        else
        begin
            reg div_clk_negedge;

            always @ (negedge clk or posedge rst)
                if (rst)
                    div_clk_negedge <= 0;
                else
                    div_clk_negedge <= div_clk_unadjusted;

            assign div_clk = div_clk_unadjusted | div_clk_negedge;
        end

    endgenerate

endmodule
