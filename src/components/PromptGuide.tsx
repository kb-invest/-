import { useState, useEffect } from 'react'
import { Sparkles, Copy, Check, MessageSquare, Lightbulb } from 'lucide-react'
import axios from 'axios'

interface Prompt {
  title: string
  prompt: string
}

const PromptGuide = () => {
  const [prompts, setPrompts] = useState<Prompt[]>([])
  const [copiedIndex, setCopiedIndex] = useState<number | null>(null)
  const [customAddress, setCustomAddress] = useState('')
  const [customBuilding, setCustomBuilding] = useState('')
  const [customType, setCustomType] = useState('오피스')

  useEffect(() => {
    fetchPrompts()
  }, [])

  const fetchPrompts = async () => {
    try {
      const API_BASE_URL = import.meta.env.VITE_API_URL || '/api'
      const response = await axios.get(`${API_BASE_URL}/genspark-prompts`)
      setPrompts(response.data.prompts)
    } catch (error) {
      console.error('프롬프트 가져오기 실패:', error)
      // 기본 프롬프트 사용
      setPrompts([
        {
          title: '부동산 특징 분석',
          prompt: '서울특별시 강남구 대치동 890-12 (테헤란로 418) 위치한 상업용 오피스 빌딩의 투자 매력도와 핵심 특징을 전문적이고 고급스럽게 3-5문장으로 작성해줘. 입지, 교통, 주변 환경을 중심으로 설명해줘.'
        },
        {
          title: '투자 하이라이트',
          prompt: '[주소]에 위치한 [건물유형] 부동산의 투자 하이라이트를 5가지로 요약해줘. 각 항목은 간결하고 임팩트 있게 작성하고, 투자자 관점에서 매력적으로 표현해줘.'
        },
        {
          title: '입지 분석',
          prompt: '[주소] 부동산의 입지적 장점을 교통(지하철, 버스, 도로), 상권, 개발 호재 측면에서 분석해줘. 전문 중개사가 고객에게 설명하는 톤으로 작성해줘.'
        },
        {
          title: '수익성 분석',
          prompt: '[건물명] 건물의 임대 수익성과 자산 가치 상승 가능성을 분석해줘. 현재 시장 상황과 향후 전망을 포함해서 투자자를 설득할 수 있게 작성해줘.'
        },
        {
          title: '매각 제안 메시지',
          prompt: '[건물명], 매각가 [금액]원의 상업용 부동산 매각 제안서에 들어갈 오프닝 메시지를 작성해줘. 투자자의 관심을 끌 수 있도록 전문적이고 고급스럽게 2-3문장으로 작성해줘.'
        }
      ])
    }
  }

  const copyToClipboard = (text: string, index: number) => {
    // 템플릿 변수 치환
    let finalText = text
      .replace(/\[주소\]/g, customAddress || '[주소]')
      .replace(/\[건물명\]/g, customBuilding || '[건물명]')
      .replace(/\[건물유형\]/g, customType)
      .replace(/\[금액\]/g, '[금액]')

    navigator.clipboard.writeText(finalText)
    setCopiedIndex(index)
    setTimeout(() => setCopiedIndex(null), 2000)
  }

  return (
    <div className="max-w-5xl mx-auto space-y-8">
      {/* Header */}
      <div className="card bg-gradient-to-r from-purple-600 to-blue-600 text-white">
        <div className="flex items-start space-x-4">
          <Sparkles size={40} className="flex-shrink-0 mt-1" />
          <div>
            <h2 className="text-3xl font-bold mb-3">GenSpark AI 프롬프트 가이드</h2>
            <p className="text-lg opacity-90">
              부동산 특징과 장점을 전문적이고 고급스럽게 표현하기 위한 AI 프롬프트 모음입니다.
              <br />
              아래 프롬프트를 GenSpark 채팅에 복사하여 사용하면, 매력적인 제안서 문구를 얻을 수 있습니다.
            </p>
          </div>
        </div>
      </div>

      {/* Custom Input Section */}
      <div className="card">
        <h3 className="text-xl font-bold text-luxury-darkblue mb-4 flex items-center">
          <Lightbulb className="mr-2 text-luxury-gold" size={24} />
          프롬프트 커스터마이징
        </h3>
        <p className="text-gray-600 mb-4">
          아래 정보를 입력하면 프롬프트에 자동으로 적용됩니다.
        </p>

        <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
          <div>
            <label className="label">주소</label>
            <input
              type="text"
              className="input-field"
              placeholder="예: 서울특별시 강남구 대치동 890-12"
              value={customAddress}
              onChange={(e) => setCustomAddress(e.target.value)}
            />
          </div>

          <div>
            <label className="label">건물명</label>
            <input
              type="text"
              className="input-field"
              placeholder="예: 다봉타워"
              value={customBuilding}
              onChange={(e) => setCustomBuilding(e.target.value)}
            />
          </div>

          <div>
            <label className="label">건물 유형</label>
            <select
              className="input-field"
              value={customType}
              onChange={(e) => setCustomType(e.target.value)}
            >
              <option value="오피스">오피스</option>
              <option value="상가">상가</option>
              <option value="빌딩">빌딩</option>
              <option value="사옥">사옥</option>
              <option value="수익형 건물">수익형 건물</option>
            </select>
          </div>
        </div>
      </div>

      {/* Prompt Cards */}
      <div className="space-y-4">
        {prompts.map((prompt, index) => (
          <div
            key={index}
            className="card hover:shadow-xl transition-shadow duration-200 border-l-4 border-luxury-gold"
          >
            <div className="flex justify-between items-start mb-4">
              <div className="flex items-center space-x-3">
                <div className="w-10 h-10 bg-luxury-darkblue text-white rounded-full flex items-center justify-center font-bold">
                  {index + 1}
                </div>
                <h3 className="text-xl font-bold text-luxury-darkblue">{prompt.title}</h3>
              </div>

              <button
                onClick={() => copyToClipboard(prompt.prompt, index)}
                className={`flex items-center space-x-2 px-4 py-2 rounded-lg font-semibold transition-all duration-200 ${
                  copiedIndex === index
                    ? 'bg-green-500 text-white'
                    : 'bg-luxury-darkblue text-white hover:bg-opacity-90'
                }`}
              >
                {copiedIndex === index ? (
                  <>
                    <Check size={18} />
                    <span>복사됨!</span>
                  </>
                ) : (
                  <>
                    <Copy size={18} />
                    <span>복사</span>
                  </>
                )}
              </button>
            </div>

            <div className="bg-gray-50 p-4 rounded-lg border border-gray-200">
              <p className="text-gray-800 leading-relaxed whitespace-pre-wrap">
                {prompt.prompt
                  .replace(/\[주소\]/g, customAddress || '[주소]')
                  .replace(/\[건물명\]/g, customBuilding || '[건물명]')
                  .replace(/\[건물유형\]/g, customType)
                  .replace(/\[금액\]/g, '[금액]')}
              </p>
            </div>

            <div className="mt-3 flex items-start space-x-2 text-sm text-gray-600">
              <MessageSquare size={16} className="flex-shrink-0 mt-1" />
              <p>
                <strong>사용법:</strong> 위 프롬프트를 GenSpark 채팅창에 붙여넣고 전송하면, AI가 전문적인 문구를 작성해줍니다.
              </p>
            </div>
          </div>
        ))}
      </div>

      {/* Tips Section */}
      <div className="card bg-blue-50 border-blue-200">
        <h3 className="text-xl font-bold text-luxury-darkblue mb-4 flex items-center">
          <Lightbulb className="mr-2 text-luxury-gold" size={24} />
          효과적인 사용 팁
        </h3>

        <ul className="space-y-3 text-gray-700">
          <li className="flex items-start space-x-3">
            <span className="text-luxury-gold font-bold text-lg">•</span>
            <p>
              <strong>구체적인 정보 추가:</strong> 프롬프트에 지하철역 거리, 주변 랜드마크, 최근 개발 호재 등 구체적인 정보를 추가하면 더 설득력 있는 결과를 얻을 수 있습니다.
            </p>
          </li>
          <li className="flex items-start space-x-3">
            <span className="text-luxury-gold font-bold text-lg">•</span>
            <p>
              <strong>톤앤매너 조정:</strong> "전문적이고", "고급스럽게", "투자자 관점에서" 등의 표현을 추가하여 원하는 스타일로 조정하세요.
            </p>
          </li>
          <li className="flex items-start space-x-3">
            <span className="text-luxury-gold font-bold text-lg">•</span>
            <p>
              <strong>여러 번 생성:</strong> 한 번에 만족스러운 결과가 나오지 않으면, 프롬프트를 약간 수정하여 다시 시도해보세요.
            </p>
          </li>
          <li className="flex items-start space-x-3">
            <span className="text-luxury-gold font-bold text-lg">•</span>
            <p>
              <strong>결과 편집:</strong> AI가 생성한 문구를 기반으로, 실제 상황에 맞게 약간의 편집을 추가하면 완벽한 제안서를 만들 수 있습니다.
            </p>
          </li>
        </ul>
      </div>

      {/* Example Section */}
      <div className="card bg-gradient-to-br from-luxury-darkblue to-blue-900 text-white">
        <h3 className="text-xl font-bold mb-4">📝 실제 사용 예시</h3>

        <div className="space-y-4">
          <div>
            <p className="font-semibold mb-2 text-luxury-gold">프롬프트 입력:</p>
            <div className="bg-white bg-opacity-10 p-4 rounded-lg">
              <p className="text-sm">
                서울특별시 강남구 대치동 890-12 (테헤란로 418) 위치한 상업용 오피스 빌딩의 투자 매력도와 핵심 특징을 전문적이고 고급스럽게 3-5문장으로 작성해줘.
              </p>
            </div>
          </div>

          <div>
            <p className="font-semibold mb-2 text-luxury-gold">AI 생성 결과:</p>
            <div className="bg-white bg-opacity-10 p-4 rounded-lg">
              <p className="text-sm leading-relaxed">
                테헤란로 중심에 위치한 프리미엄 오피스 빌딩으로, 선릉역 도보 3분 거리의 초역세권 입지를 자랑합니다. 
                강남 핵심 업무지구의 대로변에 면해 있어 탁월한 접근성과 높은 시인성을 확보하고 있으며, 
                지속적인 관리로 최상의 컨디션을 유지하고 있습니다. 주변 글로벌 기업들과 금융기관이 밀집해 있어 
                안정적인 임대 수요가 보장되며, 향후 자산 가치 상승이 기대되는 프라임 투자처입니다.
              </p>
            </div>
          </div>
        </div>
      </div>
    </div>
  )
}

export default PromptGuide
