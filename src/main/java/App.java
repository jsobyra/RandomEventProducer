import com.opencsv.CSVWriter;

import java.io.Writer;
import java.nio.file.Files;
import java.nio.file.Paths;

public class App {
    private static final Generator generator = new Generator();

    public static void main(String[] args) throws Exception {
        Writer writer = Files.newBufferedWriter(Paths.get("test2.csv"));
        CSVWriter csvWriter = new CSVWriter(writer, CSVWriter.DEFAULT_SEPARATOR,
                CSVWriter.NO_QUOTE_CHARACTER, CSVWriter.DEFAULT_ESCAPE_CHARACTER,
                CSVWriter.DEFAULT_LINE_END);

        for(int i = 0; i < 15000; i++) {
            csvWriter.writeNext(generator.generateRandomEvent().toString().split(","));
        }

        csvWriter.close();
    }
}
