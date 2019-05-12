<h1>Duplicate Ticket Project</h1>
<p><b>Authors:</b> Sergio Servantez, Parker Joncus, Manish Suthar</p>
<p><b>Advisor:</b> Dr. Robert Ellis</p>
<p>Illinois Institute of Technology</p>
<hr></hr>
<p><b>Problem Statement:</b> To gather information and investigate the practices of the City of Chicago regarding the issuing of duplicate tickets, especially those issued for expired registrations.</p>

<p><b>Project Sponsor:</b> ProPublica</p>
<p>The dataset used for this project was provided by ProPublica. See terms of use: https://www.propublica.org/datastore/terms </p>

<p><b>Prior Work:</b> This project was heavily influenced by prior articles published by ProPublica regarding various ticketing practices of the City of Chicago. Some of the more relevant articles are listed below.</p>
<p><i>The Ticket Trap</i> by David Eads and Melissa Sanchez: https://projects.propublica.org/chicago-tickets/ </p>
<p><i>Chicago Throws Out 23,000 Duplicate Tickets Issued Since 1992 to Motorists Who Didn’t Have Vehicle Stickers</i> by Melissa Sanchez and Elliot Ramos: https://www.propublica.org/article/chicago-vehicle-stickers-duplicate-tickets-thrown-out </p>

<hr></hr>
<p><b>Project Highlights</b></p>
<ul>
<li>Generated a new duplicate dataset containing every duplicate ticket from the original dataset</li>
<li>Duplicates are defined as: Same License Plate + Same Day + Same Violation</li>
<li>Added a new feature to uniquely identify duplicate groups</li>
<li>Added a new feature to identify first and repeat tickets within each duplicate group</li>
<li>Total excess fines issued by the City of Chicago: $37,198,820</li>
<li>Total number of repeats issued since 1996: 643,446</li>
<li>Total excess paid on repeat tickets: $28,288,495</li>
<li>Total excess paid on repeat expired registration tickets: $5,634,383</li>
<li>Identification of the officers who have issued the highest number of repeat tickets</li>
<li>Created multiple linear regression models to predict the number of expired plate duplicate tickets in each ward based on demographic, health, and socioeconomic data.</li>
<li>Used the regerssion models to find what factors are statistcally significant in determining ticket counts within wards and if the factors positively or negativly affect the ticket counts</li>
<li>Found that while race may not be the reason why people get more or less tickets, there is a difference in the magnitude at which different races are ticketed.</li>
</ul>

<hr></hr>
<p><b>Data</b></p>
All data can be found in this repositiory, on the Chicago Data Portal (https://data.cityofchicago.org), or in our personal Google Drive. More information can be found in the file datasets/dataset_links

<hr></hr>
<p><b>Tools</b></p>
<ul>
<li>Python</li>
<li>R</li>
<li>QGIS</li>
<li>Google Drive</li>
<li>Github</li>
</ul>
