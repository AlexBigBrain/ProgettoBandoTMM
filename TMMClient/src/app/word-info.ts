export interface WordInfo {
    "data": {
        "usable"?: [
            {
                "Word": {
                    "specificWord": string,
                    "Language": string,
                    "generalWord": string,
                    "RequestNumber": number
                },
                "Descriptions": [
                    {
                        "specificWord": string,
                        "Description": string,
                        "LangDesc": string,
                        "descriptionID": number
                    }
                ],
                "Examples": [
                    {
                        "Example": string,
                        "LangExample": string,
                        "descriptionID": number
                    }
                ],
                "SinonimsIT": string[],
                "SinonimsEN": string[],
                "TranslasionsIT": string[],
                "TranslasionsEN": string[]
            }
        ],
        "unusable"?: [
            [
                string,
                number
            ]
        ]
    },
    "status"?: string
}
