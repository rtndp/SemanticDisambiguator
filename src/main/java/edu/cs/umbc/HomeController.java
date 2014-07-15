package edu.cs.umbc;

import java.text.DateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Locale;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * Handles requests for the application home page.
 */
@Controller
public class HomeController {

	private static final Logger logger = LoggerFactory
			.getLogger(HomeController.class);

	/**
	 * Simply selects the home view to render by returning its name.
	 */
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String home(Locale locale, Model model) {
		logger.info("Welcome home! The client locale is {}.", locale);

		Date date = new Date();
		DateFormat dateFormat = DateFormat.getDateTimeInstance(DateFormat.LONG,
				DateFormat.LONG, locale);

		String formattedDate = dateFormat.format(date);

		model.addAttribute("serverTime", formattedDate);

		return "home";
	}

	@RequestMapping(value = "/process", method = RequestMethod.GET)
	public String process() {
		System.out.println("I am here!");
		return "result";
	}

	// @RequestMapping(value = "test", method = RequestMethod.GET)
	// public @ResponseBody
	// Coffee getCoffeeInXML(@PathVariable String name) {
	// System.out.println("I am here");
	// Coffee coffee = new Coffee("Arabica", 100);
	// return coffee;
	//
	// }
	//
	// @RequestMapping(value = "getList", method = RequestMethod.GET)
	// public @ResponseBody
	// CoffeeList getCoffeeListXML() {
	// CoffeeList coffeeList = new CoffeeList();
	// List<Coffee> tempCoffeeList = new ArrayList<Coffee>();
	//
	// Coffee coffee1 = new Coffee("One", 100);
	// tempCoffeeList.add(coffee1);
	//
	// Coffee coffee2 = new Coffee("Two", 200);
	// tempCoffeeList.add(coffee2);
	//
	// coffeeList.setData(tempCoffeeList);
	//
	// return coffeeList;
	//
	// }

}
