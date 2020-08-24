const puppeteer = require("puppeteer");

(async () => {
  const browser = await puppeteer.launch({ headless: false });
  const page = await browser.newPage();
  await page.goto("https://fantasy.espn.com/football/league/scoreboard?seasonId=2018&leagueId=797158&matchupPeriodId=1&mSPID=13");


  //  await page.waitFor('input[type="email"]')

  /*
    await page.type('input[type="email"]', "aarizvi")
    await page.type('input[type="password"]', "Peteiscool16x!")
    await page.click('button[label="Log In"]')
  
    */

  await page.screenshot({ path: "example.png" });


  //await page.click('.dropdown__select')
  //await page.waitFor(1000)
  //await page.click('option[value="10"]')

  results = []
  for (season = 2013; season <= 2019; season++) {
    result = { "season": season, "periods": [] }
    for (periodId = 1; periodId <= 13; periodId++) {
      //      await page.waitFor(1000)
      url = "https://fantasy.espn.com/football/league/scoreboard?seasonId=" + season + "&leagueId=797158&matchupPeriodId=" + periodId + "&mSPID=" + periodId
      await page.goto(url, { timeout: 2000 }).catch(e => void e);
      await page.waitFor(3000)
      await page.evaluate(() => window.stop())
      //      await page.reload()


      //await page.reload()
      //      await page.waitFor(1000)
      //await page.waitFor(".ScoreboardScoreCell__Competitors")
      periodValues = await page.evaluate(`Array.from(document.querySelectorAll(".ScoreboardScoreCell__Competitors")).map((c) => {
        return { 
            "names":Array.from(c.querySelectorAll(".ScoreCell__TeamName")).map((t) => {
           return t.innerText
        }),
         "scores":Array.from(c.querySelectorAll('.ScoreCell__Score')).map((t) => {
           return t.innerText
        })
        }
    });`, e => e.innerText);
      result.periods.push(periodValues)
    }
    results.push(result)
  }

})();
