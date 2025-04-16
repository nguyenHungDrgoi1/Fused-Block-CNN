// module test_read();

//     reg [7:0] buffer [0:1023]; // Dùng buffer để lưu dữ liệu tạm thời
//     integer file, i, read_count;

//     initial begin
//         // Mở file
//         file = $fopen("input_data.txt", "r");
//         if (file == 0) begin
//             $display("Error: Failed to open file.");
//             $finish;
//         end

//         // Đọc file vào buffer
//         read_count = $fread(buffer, file);
//         $fclose(file);

//         // Hiển thị kết quả
//         $display("Total bytes read: %0d", read_count);
//         for (i = 0; i < read_count; i = i + 1) begin
//             $display("Data[%0d] = %c", i, buffer[i]);
//         end

//         $fclose(file);
//     end

// endmodule

module read_file_example;
    // Khai báo một mảng 32-bit với 3 phần tử
    reg [31:0] data_array [0:2];  // Mảng chứa 3 giá trị 32-bit

    // Khai báo một biến để chỉ số của mảng
    integer i;

    initial begin
        // Đọc dữ liệu từ file vào mảng data_array
        //$fread(data_array, $fopen("input_data.txt", "r"));
        for (i = 0; i < 3; i = i + 1) begin
            $readmemh("test.txt", data_array[i]);
        end
        
        // Hiển thị các giá trị đã đọc
        $display("Đọc dữ liệu từ file:");
        for (i = 0; i < 3; i = i + 1) begin
            $display("data_array[%0d] = %b", i, data_array[i]);
        end
    end
endmodule