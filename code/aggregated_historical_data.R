
library(tidyverse)
hist_df <- read_csv("~/fantasy2020/historical_data/historical_data_flattened.csv")


teams <- owners$owner
names(teams) <- owners$name


hist_df <- hist_df %>% 
    janitor::clean_names()


replace_na_with_last<-function(x,a=!is.na(x)){
    x[which(a)[c(1,1:sum(a))][cumsum(a)+1]]
}

hist_df$season <- replace_na_with_last(hist_df$season)
hist_df <- hist_df %>%
    mutate(periods_names_001=teams[periods_names_001],
           periods_names_002=teams[periods_names_002]) 


hist_df <- hist_df %>% 
    rename(team1=periods_names_001,
           team2=periods_names_002,
           score1=periods_scores_001,
           score2=periods_scores_002)


hist_df  %>%
    filter(team1 %in% c("Greg Weidner", "Abbas Rizvi"),
           team2 %in% c("Greg Weidner", "Abbas Rizvi")) %>%
    mutate(
        winner=case_when(
            score1 > score2 ~ team1,
            score1 < score2 ~ team2
        )
    )


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
        ) %>%
        group_by(winner) %>%
        summarize(record=length(winner)) %>%
        ungroup() %>%
        arrange(-record)
}


compute_match_ups("Atif Khan", "Abbas Rizvi")

compute_match_ups("RJ White", "Tim L")

unique_owners <- unique(owners$owner)

compute_match_ups("Morgan Nickerson", "Abbas Rizvi")

hist_df  %>%
    filter(str_detect(team1, "Abbas") |
           str_detect(team2, "Abbas")) %>%
    print(n=Inf)

           