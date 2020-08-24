
library(shiny)
library(tidyverse)
hist_df <- readRDS("historical_data.rds")

owners <- readRDS("fantasy_owners.rds")
owners <- unique(owners$owner)

# owners_add <- tribble(
#     ~name, ~owner,
#     "Brown Town Clowns", "Atif Khan",
#     "Meadville Militia", "Morgan Nickerson",
#     "Medical Malpractice", "Seth Baughman",
#     "Black Juliet's",  "Brian Szabo",
#     "Dirty Dick Dave", "RJ White",
#     "Big Dick Nick", "David Ross",
#     "Diddlers on the Roof", "Arslan Rashid",
#     "Team Girth Brooks", "Jeff Parry",
#     "A$$ and TD's", "Terry Shernisky",
#     "John Brown Town Clowns", "Abbas Rizvi",
#     "The Waiver Wire", "James Russell",
#     "Team Trosch", "Eric Trosch",
#     "The Little Giants", "Greg Weidner",
#     "DeDes Nuts", "Tim L"
# )



# owners <- rbind(owners, owners_add)


compute_record <- function(owner1, owner2){
    hist_df  %>%
        filter(team1 %in% c(owner1, owner2),
               team2 %in% c(owner1, owner2)) %>%
        mutate(
            winner=case_when(
                score1 > score2 ~ team1,
                score1 < score2 ~ team2,
                score1 == score2 ~ "Draw"
            )
        ) %>%
        group_by(winner) %>%
        summarize(record=length(winner)) %>%
        ungroup() %>%
        arrange(-record)
}

compute_match_ups <- function(owner1, owner2){
    hist_df  %>%
        filter(team1 %in% c(owner1, owner2),
               team2 %in% c(owner1, owner2)) %>%
        mutate(
            winner=case_when(
                score1 > score2 ~ team1,
                score1 < score2 ~ team2,
                score1 == score2 ~ "Draw"
            )
        )
}



# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("ATIFS LEAGUE FANTASY RECORD"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            selectInput("owner1", "Enter Owner 1:", owners),
            selectInput("owner2", "Enter Owner 2:", owners),
            actionButton("button", "Done")
        ),

        # Show a plot of the generated distribution
        mainPanel(
           h1("All time record:"),
           dataTableOutput("rec_output"),
           h1("All time matchups:"),
           dataTableOutput("matchups_output")
           
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    
    records <- eventReactive(
        input$button,
        {compute_record(input$owner1, input$owner2)}
    )    
    
    matchups <- eventReactive(
        input$button,
        {compute_match_ups(input$owner1, input$owner2)}
    )    
    
    output$rec_output <- renderDataTable({
        records()
    })
    
    output$matchups_output <- renderDataTable({
        matchups()
    })
    
}

# Run the application 
shinyApp(ui = ui, server = server)
