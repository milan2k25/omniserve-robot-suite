"""
ClearTrip E2E Demo - Simple Function Version

This is the simplest possible implementation - just ONE function that does everything!
Perfect equivalent of Robot Framework test case but in pure Python + Playwright.
"""

import asyncio
from playwright.async_api import async_playwright
from datetime import datetime, timedelta
from pathlib import Path


async def search_cleartrip_flights_e2e():
    """
    🎯 SINGLE FUNCTION - COMPLETE CLEARTRIP FLIGHT SEARCH E2E TEST
    
    This function is the exact equivalent of your Robot Framework test:
    - Navigate to ClearTrip
    - Handle popups
    - Select flight section  
    - Choose cities (Bengaluru -> GOI)
    - Pick dates
    - Search flights
    - Verify results
    
    Returns:
        bool: True if successful, False if failed
    """
    
    # Create screenshots directory
    Path("screenshots").mkdir(exist_ok=True)
    
    print("🚀 Starting ClearTrip Flight Search E2E Automation...")
    print("=" * 60)
    
    playwright = None
    browser = None
    
    try:
        # 🌐 Setup Browser
        playwright = await async_playwright().start()
        browser = await playwright.chromium.launch(
            headless=False,  # Set to True for headless
            slow_mo=1000     # Slow down for visibility
        )
        page = await browser.new_page(viewport={'width': 1920, 'height': 1080})
        
        print("✅ Step 1: Browser launched successfully")
        
        # 🏠 Navigate to ClearTrip  
        await page.goto("https://cleartrip.com", timeout=30000)
        await page.screenshot(path="screenshots/01_homepage.png")
        print("✅ Step 2: Navigated to ClearTrip homepage")
        
        # 🚫 Handle Popup (if exists)
        try:
            popup = await page.wait_for_selector("svg[data-testid='closeIcon']", timeout=5000)
            if popup:
                await popup.click()
                print("✅ Step 3: Popup closed")
        except:
            print("✅ Step 3: No popup found")
        
        # ✈️ Ensure Flight Section is Selected
        try:
            # Check if already selected
            flights_selected = await page.is_visible("//h3[text()='Flights']")
            if not flights_selected:
                flights_section = await page.wait_for_selector("//p[text()='Flights']", timeout=10000)
                await flights_section.click()
                print("✅ Step 4: Flight section selected")
            else:
                print("✅ Step 4: Flight section already active")
        except Exception as e:
            print(f"⚠️  Step 4: Flight section handling - {e}")
        
        # 🔄 Select Round Trip
        try:
            one_way_btn = await page.wait_for_selector("//span[text()='One way']", timeout=10000)
            await one_way_btn.click()
            await page.wait_for_timeout(1000)
            
            round_trip = await page.wait_for_selector("//li//div//p[text()='Round trip']", timeout=5000)
            await round_trip.click()
            await page.wait_for_timeout(1000)
            print("✅ Step 5: Round trip selected")
        except Exception as e:
            print(f"⚠️  Step 5: Trip type selection - {e}")
            
        await page.screenshot(path="screenshots/02_setup_complete.png")
        
        # 🏙️ Enter Cities: Bengaluru -> GOI
        try:
            # From City
            from_city = await page.wait_for_selector("[placeholder='Where from?']", timeout=10000)
            await from_city.click()
            await from_city.fill("Bengaluru")
            await page.wait_for_timeout(2000)
            
            # Select first suggestion
            suggestion = await page.wait_for_selector("(//ul[@class='airportList']//li//p)[1]", timeout=10000)
            await suggestion.click()
            await page.wait_for_timeout(1000)
            print("✅ Step 6a: From city 'Bengaluru' entered")
            
            # To City
            to_city = await page.wait_for_selector("[placeholder='Where to?']", timeout=10000)
            await to_city.click()
            await to_city.fill("GOI")
            await page.wait_for_timeout(2000)
            
            # Select first suggestion  
            suggestion = await page.wait_for_selector("(//ul[@class='airportList']//li//p)[1]", timeout=10000)
            await suggestion.click()
            await page.wait_for_timeout(1000)
            print("✅ Step 6b: To city 'GOI' entered")
            
        except Exception as e:
            print(f"❌ Step 6: City selection failed - {e}")
            return False
            
        await page.screenshot(path="screenshots/03_cities_selected.png")
        
        # 📅 Select Dates (7 days from today + 14 day trip)
        try:
            # Calculate dates
            departure_date = datetime.now() + timedelta(days=7)
            return_date = departure_date + timedelta(days=14)
            
            formatted_departure = departure_date.strftime("%a %b %d %Y")
            formatted_return = return_date.strftime("%a %b %d %Y")
            
            print(f"📅 Selecting dates: {formatted_departure} -> {formatted_return}")
            
            # Click departure date selector
            date_selector = await page.wait_for_selector("[data-testid='dateSelectOnward']", timeout=10000)
            await date_selector.click()
            await page.wait_for_timeout(1000)
            
            # Select departure date
            departure_locator = f"//div[@aria-label='{formatted_departure}']"
            departure_element = await page.wait_for_selector(departure_locator, timeout=10000)
            await departure_element.click()
            await page.wait_for_timeout(1000)
            print(f"✅ Step 7a: Departure date selected: {formatted_departure}")
            
            # Select return date
            return_locator = f"//div[@aria-label='{formatted_return}']"  
            return_element = await page.wait_for_selector(return_locator, timeout=10000)
            await return_element.click()
            await page.wait_for_timeout(1000)
            print(f"✅ Step 7b: Return date selected: {formatted_return}")
            
        except Exception as e:
            print(f"❌ Step 7: Date selection failed - {e}")
            return False
            
        await page.screenshot(path="screenshots/04_dates_selected.png")
        
        # 🔍 Search for Flights
        try:
            search_button = await page.wait_for_selector("//h4[text()='Search flights']", timeout=10000)
            await search_button.click()
            print("✅ Step 8: Search button clicked")
            
            # Wait for results (this might take time)
            print("⏳ Waiting for flight results...")
            results = await page.wait_for_selector("//div[contains(@class,'yucvr')]", timeout=60000)
            
            if results:
                print("✅ Step 9: Flight results loaded successfully!")
                await page.screenshot(path="screenshots/05_flight_results.png")
            else:
                print("❌ Step 9: No flight results found")
                return False
                
        except Exception as e:
            print(f"❌ Step 8-9: Flight search failed - {e}")
            await page.screenshot(path="screenshots/05_search_error.png")
            return False
        
        # 🎯 Final Verification
        results_visible = await page.is_visible("//div[contains(@class,'yucvr')]")
        if results_visible:
            page_title = await page.title()
            print(f"✅ Final Verification: Results page loaded - {page_title}")
            await page.screenshot(path="screenshots/06_final_verification.png")
            
            print("=" * 60)
            print("🎉 SUCCESS! Complete E2E flight search automation completed!")
            print("📸 Screenshots saved in 'screenshots' directory")
            print("✈️  Flight search: Bengaluru -> GOI (Round trip)")
            print("=" * 60)
            
            # Keep browser open for 5 seconds to see results
            await page.wait_for_timeout(5000)
            return True
        else:
            print("❌ Final Verification Failed: Results not visible")
            return False
            
    except Exception as e:
        print(f"💥 CRITICAL ERROR: {str(e)}")
        return False
        
    finally:
        # 🧹 Cleanup
        if browser:
            await browser.close()
        if playwright:
            await playwright.stop()
        print("🧹 Browser cleanup completed")


# 🚀 Simple execution function
async def main():
    """Run the simple E2E test"""
    print("🎭 ClearTrip Flight Search - Simple E2E Automation")
    print("🎯 This is equivalent to your Robot Framework test case!")
    
    success = await search_cleartrip_flights_e2e()
    
    if success:
        print("\n🏆 Test Status: PASSED ✅")
        print("💡 Check screenshots directory for execution evidence")
    else:
        print("\n💥 Test Status: FAILED ❌") 
        print("🔍 Check error screenshots and logs for debugging")
    
    return success


# 📍 Entry point
if __name__ == "__main__":
    """
    Run this file directly for simple E2E test execution:
    
    python simple_cleartrip_e2e.py
    """
    asyncio.run(main())