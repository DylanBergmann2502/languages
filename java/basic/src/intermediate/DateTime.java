package intermediate;

import java.time.*;
import java.time.format.DateTimeFormatter;

public class DateTime {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		LocalDate now = LocalDate.now();
		System.out.println(now);
		//dates
		LocalDate ld = LocalDate.of(2021, Month.JANUARY,31); // format = yyyy-mm-dd
		System.out.println(ld);
		
		//times
		LocalTime lt = LocalTime.of(14,30);
		System.out.println(lt);
		
		//date and times
		LocalDateTime ldt = LocalDateTime.of(ld, lt);
		System.out.println(ldt);
		
		//zoned date and times
		ZonedDateTime zdt = ZonedDateTime.of(ldt, ZoneId.of("America/Scoresbysund"));
//		for (String zone : ZoneId.getAvailableZoneIds()) {
//			System.out.println(zone);
//		}		
		System.out.println(zdt);
		
		//time operators
		ld = ld.plusMonths(1);
		ld.minusDays(4);
		System.out.println(ld);
		
		//date time formatter
		DateTimeFormatter dtf = DateTimeFormatter.ofPattern("dd.MMMM.yyyy"); // ("dd MM yyyy");
		System.out.println(ld.format(dtf));
		System.out.println(dtf.format(ld));
	}

}
