import { useState } from 'react'
import { Search, Upload, Download, Tv, Printer, MapPin, DollarSign, Image as ImageIcon, Building, Loader2 } from 'lucide-react'
import axios from 'axios'

interface PropertyData {
  address: string
  project_name: string
  building_name: string
  sale_price: string
  rental_price: string
  rental_details: string
  key_features: string[]
  location_description: string
  api_key: string
  building_info: any
  land_info: any
  main_image: string
  interior_images: string[]
  other_images: string[]
  company_info: string
}

const PropertyForm = () => {
  // localStorage에서 저장된 API 키 불러오기
  const savedApiKey = localStorage.getItem('realestate_api_key') || ''
  
  const [formData, setFormData] = useState<PropertyData>({
    address: '',
    project_name: '',
    building_name: '',
    sale_price: '',
    rental_price: '',
    rental_details: '',
    key_features: ['', '', ''],
    location_description: '',
    api_key: savedApiKey,
    building_info: {},
    land_info: {},
    main_image: '',
    interior_images: [],
    other_images: [],
    company_info: '이음프로퍼티 부동산중개법인'
  })

  const [loading, setLoading] = useState(false)
  const [fetchingData, setFetchingData] = useState(false)
  const [message, setMessage] = useState('')

  // API 베이스 URL - 환경 변수 또는 상대 경로 사용
  const API_BASE_URL = import.meta.env.VITE_API_URL || '/api'

  const handleInputChange = (field: string, value: any) => {
    setFormData(prev => ({ ...prev, [field]: value }))
    
    // API 키가 변경되면 localStorage에 저장
    if (field === 'api_key' && value) {
      localStorage.setItem('realestate_api_key', value)
    }
  }

  const handleFeatureChange = (index: number, value: string) => {
    const newFeatures = [...formData.key_features]
    newFeatures[index] = value
    setFormData(prev => ({ ...prev, key_features: newFeatures }))
  }

  const fetchPropertyData = async () => {
    if (!formData.address || !formData.api_key) {
      setMessage('⚠️ 주소와 API 키를 입력해주세요.')
      return
    }

    setFetchingData(true)
    setMessage('🔍 공공데이터포털에서 정보를 가져오는 중...')

    try {
      const response = await axios.post(`${API_BASE_URL}/fetch-property-data`, {
        address: formData.address,
        api_key: formData.api_key
      })

      if (response.data.success) {
        setFormData(prev => ({
          ...prev,
          building_info: response.data.building_info,
          land_info: response.data.land_info
        }))
        setMessage('✅ 건축물/토지 정보를 성공적으로 가져왔습니다!')
      }
    } catch (error: any) {
      setMessage(`❌ 데이터 조회 실패: ${error.response?.data?.error || error.message}`)
    } finally {
      setFetchingData(false)
    }
  }

  const handleImageUpload = async (file: File, type: 'main' | 'interior' | 'other') => {
    const formDataImg = new FormData()
    formDataImg.append('image', file)
    formDataImg.append('type', type)

    try {
      const response = await axios.post(`${API_BASE_URL}/upload-image`, formDataImg, {
        headers: { 'Content-Type': 'multipart/form-data' }
      })

      if (response.data.success) {
        if (type === 'main') {
          handleInputChange('main_image', response.data.url)
        } else if (type === 'interior') {
          handleInputChange('interior_images', [...formData.interior_images, response.data.url])
        } else {
          handleInputChange('other_images', [...formData.other_images, response.data.url])
        }
        setMessage('✅ 이미지가 업로드되었습니다!')
      }
    } catch (error: any) {
      setMessage(`❌ 이미지 업로드 실패: ${error.message}`)
    }
  }

  const generatePPTX = async (templateType: 'briefing' | 'print') => {
    setLoading(true)
    setMessage(`📄 ${templateType === 'briefing' ? 'TV 브리핑용' : '인쇄용'} 제안서를 생성하는 중...`)

    try {
      const response = await axios.post(
        `${API_BASE_URL}/generate-pptx`,
        {
          template_type: templateType,
          property_data: formData
        },
        {
          responseType: 'blob'
        }
      )

      // 파일 다운로드
      const url = window.URL.createObjectURL(new Blob([response.data]))
      const link = document.createElement('a')
      link.href = url
      link.setAttribute('download', `${formData.building_name || '제안서'}_${templateType}.pptx`)
      document.body.appendChild(link)
      link.click()
      link.remove()

      setMessage('✅ 제안서가 성공적으로 생성되었습니다!')
    } catch (error: any) {
      setMessage(`❌ 제안서 생성 실패: ${error.message}`)
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="max-w-6xl mx-auto space-y-8">
      {/* Message Alert */}
      {message && (
        <div className="card bg-blue-50 border-blue-200">
          <p className="text-center text-blue-800 font-medium">{message}</p>
        </div>
      )}

      {/* Section 1: API 설정 및 주소 입력 */}
      <div className="card">
        <h2 className="text-2xl font-bold text-luxury-darkblue mb-6 flex items-center">
          <MapPin className="mr-3 text-luxury-gold" size={28} />
          1. 부동산 기본 정보
        </h2>

        <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
          <div>
            <label className="label">공공데이터포털 API 키</label>
            <input
              type="text"
              className="input-field"
              placeholder="API 인증키를 입력하세요"
              value={formData.api_key}
              onChange={(e) => handleInputChange('api_key', e.target.value)}
            />
            <p className="text-xs text-gray-500 mt-1">
              * 공공데이터포털에서 건축물대장, 토지대장 API 키 발급 필요
            </p>
          </div>

          <div>
            <label className="label">지번 또는 도로명 주소</label>
            <div className="flex space-x-2">
              <input
                type="text"
                className="input-field"
                placeholder="예: 서울특별시 강남구 대치동 890-12"
                value={formData.address}
                onChange={(e) => handleInputChange('address', e.target.value)}
              />
              <button
                onClick={fetchPropertyData}
                disabled={fetchingData}
                className="btn-primary whitespace-nowrap"
              >
                {fetchingData ? (
                  <Loader2 className="animate-spin" size={20} />
                ) : (
                  <Search size={20} />
                )}
              </button>
            </div>
          </div>
        </div>
      </div>

      {/* Section 2: 프로젝트 정보 */}
      <div className="card">
        <h2 className="text-2xl font-bold text-luxury-darkblue mb-6 flex items-center">
          <Building className="mr-3 text-luxury-gold" size={28} />
          2. 프로젝트 정보
        </h2>

        <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
          <div>
            <label className="label">프로젝트명</label>
            <input
              type="text"
              className="input-field"
              placeholder="예: 상업용 부동산 투자 기회"
              value={formData.project_name}
              onChange={(e) => handleInputChange('project_name', e.target.value)}
            />
          </div>

          <div>
            <label className="label">건물명</label>
            <input
              type="text"
              className="input-field"
              placeholder="예: 다봉타워"
              value={formData.building_name}
              onChange={(e) => handleInputChange('building_name', e.target.value)}
            />
          </div>
        </div>

        <div className="mt-6">
          <label className="label">입지 및 특징 설명 (GenSpark AI 활용)</label>
          <textarea
            className="input-field"
            rows={4}
            placeholder="GenSpark 채팅에서 AI로 생성한 부동산 특징과 장점을 입력하세요..."
            value={formData.location_description}
            onChange={(e) => handleInputChange('location_description', e.target.value)}
          />
          <p className="text-xs text-gray-500 mt-1">
            💡 Tip: 'AI 프롬프트 가이드' 탭에서 효과적인 프롬프트를 확인하세요!
          </p>
        </div>
      </div>

      {/* Section 3: 매각/임대 정보 */}
      <div className="card">
        <h2 className="text-2xl font-bold text-luxury-darkblue mb-6 flex items-center">
          <DollarSign className="mr-3 text-luxury-gold" size={28} />
          3. 매각 및 임대 정보
        </h2>

        <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
          <div>
            <label className="label">매각가</label>
            <input
              type="text"
              className="input-field"
              placeholder="예: 2,190억"
              value={formData.sale_price}
              onChange={(e) => handleInputChange('sale_price', e.target.value)}
            />
          </div>

          <div>
            <label className="label">임대료</label>
            <input
              type="text"
              className="input-field"
              placeholder="예: 평당 50만원"
              value={formData.rental_price}
              onChange={(e) => handleInputChange('rental_price', e.target.value)}
            />
          </div>
        </div>

        <div className="mt-6">
          <label className="label">임대 내역</label>
          <textarea
            className="input-field"
            rows={3}
            placeholder="현재 임대 현황 및 세부 내역을 입력하세요..."
            value={formData.rental_details}
            onChange={(e) => handleInputChange('rental_details', e.target.value)}
          />
        </div>
      </div>

      {/* Section 4: 핵심 특징 */}
      <div className="card">
        <h2 className="text-2xl font-bold text-luxury-darkblue mb-6">
          4. 핵심 특징 (최대 3개)
        </h2>

        <div className="space-y-4">
          {[0, 1, 2].map((index) => (
            <div key={index}>
              <label className="label">특징 {index + 1}</label>
              <input
                type="text"
                className="input-field"
                placeholder={`예: ${index === 0 ? '선릉역 초역세권' : index === 1 ? '테헤란로 대로변' : '프리미엄 오피스'}`}
                value={formData.key_features[index]}
                onChange={(e) => handleFeatureChange(index, e.target.value)}
              />
            </div>
          ))}
        </div>
      </div>

      {/* Section 5: 이미지 업로드 */}
      <div className="card">
        <h2 className="text-2xl font-bold text-luxury-darkblue mb-6 flex items-center">
          <ImageIcon className="mr-3 text-luxury-gold" size={28} />
          5. 이미지 업로드
        </h2>

        <div className="space-y-6">
          <div>
            <label className="label">메인 사진</label>
            <input
              type="file"
              accept="image/*"
              onChange={(e) => e.target.files?.[0] && handleImageUpload(e.target.files[0], 'main')}
              className="input-field"
            />
            {formData.main_image && (
              <p className="text-sm text-green-600 mt-2">✅ 메인 이미지 업로드 완료</p>
            )}
          </div>

          <div>
            <label className="label">내부 사진</label>
            <input
              type="file"
              accept="image/*"
              multiple
              onChange={(e) => {
                if (e.target.files) {
                  Array.from(e.target.files).forEach(file => handleImageUpload(file, 'interior'))
                }
              }}
              className="input-field"
            />
            {formData.interior_images.length > 0 && (
              <p className="text-sm text-green-600 mt-2">✅ {formData.interior_images.length}개 이미지 업로드 완료</p>
            )}
          </div>

          <div>
            <label className="label">기타 사진</label>
            <input
              type="file"
              accept="image/*"
              multiple
              onChange={(e) => {
                if (e.target.files) {
                  Array.from(e.target.files).forEach(file => handleImageUpload(file, 'other'))
                }
              }}
              className="input-field"
            />
            {formData.other_images.length > 0 && (
              <p className="text-sm text-green-600 mt-2">✅ {formData.other_images.length}개 이미지 업로드 완료</p>
            )}
          </div>
        </div>
      </div>

      {/* Section 6: 회사 정보 */}
      <div className="card">
        <h2 className="text-2xl font-bold text-luxury-darkblue mb-6">
          6. 회사 정보
        </h2>

        <div>
          <label className="label">중개법인명 및 연락처</label>
          <input
            type="text"
            className="input-field"
            placeholder="예: 이음프로퍼티 부동산중개법인 | 대표 홍길동 | 010-1234-5678"
            value={formData.company_info}
            onChange={(e) => handleInputChange('company_info', e.target.value)}
          />
        </div>
      </div>

      {/* Generate Buttons */}
      <div className="card bg-gradient-to-r from-luxury-darkblue to-blue-900 text-white">
        <h2 className="text-2xl font-bold mb-6 text-center">제안서 생성</h2>

        <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
          <button
            onClick={() => generatePPTX('briefing')}
            disabled={loading}
            className="bg-white text-luxury-darkblue hover:bg-gray-100 font-bold py-6 px-8 rounded-xl transition-all duration-200 shadow-lg hover:shadow-xl flex items-center justify-center space-x-3 disabled:opacity-50"
          >
            {loading ? (
              <>
                <Loader2 className="animate-spin" size={24} />
                <span>생성 중...</span>
              </>
            ) : (
              <>
                <Tv size={24} />
                <span>TV 브리핑용 생성</span>
              </>
            )}
          </button>

          <button
            onClick={() => generatePPTX('print')}
            disabled={loading}
            className="bg-luxury-gold hover:bg-yellow-500 text-luxury-darkblue font-bold py-6 px-8 rounded-xl transition-all duration-200 shadow-lg hover:shadow-xl flex items-center justify-center space-x-3 disabled:opacity-50"
          >
            {loading ? (
              <>
                <Loader2 className="animate-spin" size={24} />
                <span>생성 중...</span>
              </>
            ) : (
              <>
                <Printer size={24} />
                <span>인쇄용 생성</span>
              </>
            )}
          </button>
        </div>

        <p className="text-center text-sm mt-6 text-gray-200">
          버튼을 클릭하면 선택한 형식의 PPTX 제안서가 자동으로 다운로드됩니다.
        </p>
      </div>
    </div>
  )
}

export default PropertyForm
