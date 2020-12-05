#### UI file ####

shinyUI(bs4DashPage(
    
    dashboardHeader("Triathlon Results"),
    
    bs4DashSidebar(
        bs4SidebarMenu(
            bs4SidebarMenuItem(
                "Results",
                tabName = "results",
                icon = "table"
            )
        )
        
    ),
    
    bs4DashBody(
        bs4TabItems(
            bs4TabItem(
                tabName = "results",
                fluidRow(
                    box(
                        title = "Filters",
                        width = 12,
                        collapsible = TRUE,
                        closable = FALSE,
                        status = "dark",
                        solidheader = TRUE,
                        tags$div(
                            HTML(
                                paste("<h4>Triathlon Results</h4>",
                                      "<p>This tool has been developed by <a href='http://www.bluecattechnical.co.uk' target='blank'>Blue Cat Technical Ltd</a>.  If you have any queries please <a href = 'mailto:johnpeters@bluecattechnical.co.uk?Subject=Triathlon%20App'>email me</a></p>",
                                      "<p>This is  a basic app to filter and download results from the <a href='https://www.triathlon.org/' target='blank'>Triathlon.org website</a>  </p>",
                                      "<p>Apply the date range filters; select one or more events (shift and click to select a range of rows) from the Events table; select Individual or Team and then one or more programmes from the resulting Programmes table to see the results.  Team events show the individual times & splits for each team member.</p>",
                                      "<style>.bmc-button img{width: 27px !important;margin-bottom: 1px !important;box-shadow: none !important;border: none !important;vertical-align: middle !important;}.bmc-button{line-height: 36px !important;height:37px !important;text-decoration: none !important;display:inline-flex !important;color:#FFFFFF !important;background-color:#FF813F !important;border-radius: 3px !important;border: 1px solid transparent !important;padding: 1px 9px !important;font-size: 22px !important;letter-spacing: 0.6px !important;box-shadow: 0px 1px 2px rgba(190, 190, 190, 0.5) !important;-webkit-box-shadow: 0px 1px 2px 2px rgba(190, 190, 190, 0.5) !important;margin: 0 auto !important;font-family:'Cookie', cursive !important;-webkit-box-sizing: border-box !important;box-sizing: border-box !important;-o-transition: 0.3s all linear !important;-webkit-transition: 0.3s all linear !important;-moz-transition: 0.3s all linear !important;-ms-transition: 0.3s all linear !important;transition: 0.3s all linear !important;}.bmc-button:hover, .bmc-button:active, .bmc-button:focus {-webkit-box-shadow: 0px 1px 2px 2px rgba(190, 190, 190, 0.5) !important;text-decoration: none !important;box-shadow: 0px 1px 2px 2px rgba(190, 190, 190, 0.5) !important;opacity: 0.85 !important;color:#FFFFFF !important;}</style><link href='https://fonts.googleapis.com/css?family=Cookie' rel='stylesheet'><a class='bmc-button' target='_blank' href='https://www.buymeacoffee.com/ifkBCoL8l'><img src='https://www.buymeacoffee.com/assets/img/BMC-btn-logo.svg' alt='Buy me a coffee'><span style='margin-left:5px'>Buy me a coffee</span></a>")
                            )
                        ),
                        dateRangeInput('dateRange',
                                       label = 'Date range input: yyyy-mm-dd',
                                       start = Sys.Date() - 365, end = Sys.Date()
                        )
                    ),
                    box(
                        title = "Events",
                        width = 12,
                        collapsible = TRUE,
                        closable = FALSE,
                        status = "dark",
                        solidheader = TRUE,
                        DT::dataTableOutput("events")
                    ),
                    box(
                        title = "Programme",
                        width = 12,
                        collapsible = TRUE,
                        closable = FALSE,
                        status = "dark",
                        solidheader = TRUE,
                        radioButtons("ind_team",label = "", choices = c("Individual" = 1, "Team" = 2), inline = TRUE),
                        DT::dataTableOutput("prog")
                    ),
                    box(
                        title = "Results",
                        width = 12,
                        collapsible = TRUE,
                        closable = FALSE,
                        status = "dark",
                        solidheader = TRUE,
                        downloadButton("downloadData", "Download as CSV"),
                        DT::dataTableOutput("results")
                    )
                )
            )
        )
        
    )
    
))
