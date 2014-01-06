{
    "nodes": [
              { "name": "OrganSystem", "group": 0 }, 
              { "name": "EtiologicAgent", "group": 1},
              { "name": "EntryPoint", "group": 2},              
              { "name": "Disease", "group": 3},
			  { "name": "Finding", "group": 4},
			  { "name": "Question", "group": 5}              
              ],
    "links": [
                
                { "source": 1, "target": 0, "value": 7, "name":"residesIn" },
                { "source": 1, "target": 3, "value": 7, "name":"induces" },                
				{ "source": 1, "target": 2, "value": 7, "name":"enters" },
				{ "source": 3, "target": 4, "value": 7, "name":"causes" },
				{ "source": 5, "target": 4, "value": 7, "name":"confirms" },
				{ "source": 4, "target": 2, "value": 7, "name":"confirm" },
				{ "source": 0, "target": 0, "value": 7, "name":"includes" },
				{ "source": 4, "target": 4, "value": 7, "name":"includes" },
				{ "source": 3, "target": 3, "value": 7, "name":"causes" },
				{ "source": 3, "target": 3, "value": 7, "name":"subtype", "selfrelationship":"2" },
				{ "source": 1, "target": 1, "value": 7, "name":"subtype" }
             ]			
}